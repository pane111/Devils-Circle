extends CharacterBody2D

#Note: "Character" is not meant to be used by itself.
#Make a new script that inherits from it!

@export var move_speed = 140.0
var area_mult=1.0
@export var anim: AnimatedSprite2D
@export var moving=false
@export var can_move=true
signal jumped
signal move_completed
@export var lastdir = Vector2.ZERO
var fake_3d=false
@export var affected_by_fake_3d=true
var scale_speed=1.0
@export var simplified_animation=false
var init_ms=1.0
func _ready() -> void:
	init_ms = move_speed
	
	await get_tree().process_frame
	print_debug(str(GameManager.cur_scene))
	set_f3d(GameManager.cur_scene.is_fake_3d,GameManager.cur_scene.scale_speed)
	area_mult = GameManager.cur_scene.move_mult

func _physics_process(_delta: float) -> void:
	if fake_3d:
			var sc = (((global_position.y * scale_speed)/400)+1.0)
			anim.scale=Vector2.ONE * sc
			move_speed = init_ms * sc
	if moving:
		
		move_and_slide()
func set_f3d(val,spd):
	if !affected_by_fake_3d: return
	if fake_3d==false:
		init_ms = move_speed
	fake_3d=val
	
	if !val:
		anim.scale=Vector2.ONE
		move_speed=init_ms
		return
	move_speed = init_ms * (((global_position.y * scale_speed)/400)+1.0)
	scale_speed=spd
	anim.scale=Vector2.ONE * (((global_position.y * scale_speed)/400)+1.0)
#Move character for a specific amount of time in a direction
func move_char(dir,duration,speed_mult=1.0,forced=false):
	if !forced:
		if !can_move: return
	var t = get_tree().create_timer(duration)
	moving=true
	velocity = dir.normalized() * move_speed * speed_mult
	animate(velocity,true,true)
	await t.timeout
	if !forced:
		if !can_move: return
	velocity = Vector2.ZERO
	lastdir = dir
	animate(dir,false,true)
	moving = false
	move_completed.emit()

func look_in_direction(dir: Vector2):
	animate(dir.normalized(),false,true)
	lastdir=dir.normalized()

func look_at_object(obj):
	var o = CutsceneManager.entities[obj]
	var dir = (o.global_position-global_position).normalized()
	look_in_direction(dir)
func look_at_position(pos):
	var dir = (pos-global_position).normalized()
	look_in_direction(dir)
#Push character (can be used for knockback, dash, etc)
func push_char(dir,duration,force,decaying=false,forced=false):
	if !forced:
		if !can_move: return
	var t = get_tree().create_timer(duration)
	moving=true
	velocity = dir.normalized() * force
	if decaying:
		var tween = get_tree().create_tween()
		tween.tween_property(self,"velocity",Vector2.ZERO,duration)
	await t.timeout
	if !forced:
		if !can_move: return
	velocity = Vector2.ZERO
	moving = false
	move_completed.emit()

#Move character to a specific position
func move_char_to_position(pos,speed_mult=1.0):
	var t = get_tree().create_tween()
	var dir = pos-global_position
	var dist = dir.length()
	t.tween_property(self,"global_position",pos,dist/(move_speed*speed_mult))
	animate(dir.normalized(),true,true)
	await t.finished
	animate(dir.normalized(),false,true)
	lastdir = dir
	move_completed.emit()

#Play specific animation
func set_anim(a_name):
	anim.play(a_name)


func jump(dur=0.25,height=16.0):
	$JumpSound.play()
	var stored_offset = anim.offset
	var t = get_tree().create_tween()
	t.tween_property(anim,"offset",stored_offset+Vector2(0,-height),dur/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await t.finished
	t = get_tree().create_tween()
	t.tween_property(anim,"offset",stored_offset,dur/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await t.finished
	jumped.emit()

#Set movement/idle animation
func animate(dir: Vector2, move = false, setanim = false):
	
	if simplified_animation:
		var a_name="idle"
		if move:
			a_name="move"
		if dir.x < 0:
			anim.flip_h=true
		elif dir.x > 0:
			anim.flip_h=false
		if setanim:
			anim.animation = a_name
			anim.play()
		return
			
	
	var prefix = "idle_"
	if move: prefix="move_"
	var a_name=""
	
	var suffix="down"
	if abs(dir.x) > abs(dir.y):
		suffix = "right" if dir.x > 0 else "left"
	else:
		suffix = "down" if dir.y > 0 else "up"
	
	a_name = prefix+suffix
		
	if setanim:
		anim.animation = a_name
		anim.play()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete():
	pass
