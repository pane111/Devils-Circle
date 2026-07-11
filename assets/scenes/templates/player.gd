extends "res://character.gd"

@export var sprintspeed = 2.0
@export var sprint_enabled=true #Disable this if you want no sprinting
@onready var cam_pivot=$CameraPivot #The camera will follow this
@export_range(0.0,256.0) var max_cam_offset = 128.0
@export var cam_speed=0.5
@onready var icast = $InteractionCast
@export_range(0.0,256.0) var max_interaction_range = 32.0
var is_sprinting=false
var handle_input = true : set = _set_input
var can_inter = false
var cur_inter
var speedmult = 1.0
signal input_enabled

func _set_input(val):
	handle_input = val
	input_enabled.emit()

func set_collision(val):
	print_debug("Setting player collision to " + str(val))
	$CollisionShape2D.set_deferred("disabled",!val)

func _ready() -> void:
	_set_input(true)
	lastdir = Vector2.DOWN
	DialogueManager.dialogue_started.connect(func(_info = null): set_collision(false))
	DialogueManager.dialogue_ended.connect(func(_info = null): set_collision(true))

func _process(delta: float) -> void:
	if velocity.length() > 0:
		cam_pivot.position = lerp(cam_pivot.position,Vector2.ZERO+velocity.normalized()*max_cam_offset,cam_speed*delta)

func _unhandled_input(_event: InputEvent) -> void:
	if !handle_input:
		return
	var inp = Input.get_vector("left","right","up","down")
	if Input.is_action_just_pressed("sprint") and sprint_enabled:
		is_sprinting=!is_sprinting
		GameManager.set_sprint(is_sprinting)
	
	if Input.is_action_just_pressed("action"):
		attack()
		return
	
	if is_sprinting:
		speedmult = sprintspeed
	else:
		speedmult=1.0
	
	if lastdir == null: lastdir=Vector2.ZERO
	velocity = inp.normalized() * move_speed * speedmult * area_mult
	icast.target_position = lastdir.normalized()*max_interaction_range
	anim.speed_scale = speedmult
	if inp.length() > 0:
		lastdir = inp.normalized()
		moving=true
		animate(velocity,true,true)
	else:
		moving=false
		animate(lastdir,false,true)

	if Input.is_action_just_pressed("ok") && can_inter && cur_inter!=null:
		cur_inter.on_interact()
		velocity = Vector2.ZERO
		animate(lastdir,false,true)

func attack():
	can_move=false
	handle_input=false
	moving=false
	anim.speed_scale = 1.0
	await get_tree().process_frame
	velocity=Vector2.ZERO
	var prefix = "atk_"
	var suffix = "down"
	var dir = lastdir if lastdir != null else Vector2.DOWN
	
	if abs(dir.x) > abs(dir.y):
		suffix = "right" if dir.x > 0 else "left"
	else:
		suffix = "down" if dir.y > 0 else "up"
	var anim_name = prefix+suffix
	anim.play(anim_name)
	$Slash.play()
	#print_debug("Anim name: " + anim_name)
	await anim.animation_finished
	handle_input=true
	can_move=true
	animate(lastdir,false,true)
	#await get_tree().process_frame
	var i_e = InputEventAction.new()
	i_e.action="do_input"
	i_e.pressed=true
	Input.parse_input_event(i_e)
	

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if icast.is_colliding() && handle_input:
		var col = icast.get_collider(0)
		if col == null: return
		if col.is_in_group("interactable"):
			can_inter=true
			cur_inter=col
		else:
			can_inter=false
	else:
		can_inter=false
	#global_position = global_position.clamp(Vector2.ZERO,Vector2(99999,99999))
