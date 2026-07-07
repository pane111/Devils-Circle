extends "res://character.gd"


@export var target: Node2D
@export var offset: Vector2
@export var maintained_distance=8.0
@export var following=true
var nocol = false
var speed_mult=1.0
var in_dialog=false
func _ready() -> void:
	DialogueManager.dialogue_started.connect(func(_info = null): set_dia(true))
	DialogueManager.dialogue_ended.connect(func(_info = null): set_dia(false))
	GameManager.sprint_on.connect(sprint_on)
	GameManager.sprint_off.connect(sprint_off)


func set_dia(val):
	in_dialog=val
	moving=false
	velocity = Vector2.ZERO
	
	animate(lastdir,false,true)

func set_following(val):
	following=val

func set_active(val):
	visible=val
	set_following(val)

func reset_pos():
	global_position = target.global_position

func sprint_on():
	speed_mult=1.5
	anim.speed_scale=speed_mult
func sprint_off():
	speed_mult=1.0
	anim.speed_scale=speed_mult

func _process(delta: float) -> void:
	if !following: return
	if in_dialog: return
	var tpos = target.global_position + offset.rotated(target.angle + deg_to_rad(90))
	var dir = tpos-global_position
	
	var dist = dir.length()
	if dist > maintained_distance:
		if dist > 100 && !nocol:
			$CollisionShape2D.set_deferred("disabled",true)
			jump()
			nocol=true
		velocity = lerp(velocity,dir.normalized()*move_speed * speed_mult,delta*8)
		moving=true
		animate(velocity.normalized(),true,true)
		lastdir=velocity.normalized()
	else:
		velocity = lerp(velocity,Vector2.ZERO,delta*5)
		$CollisionShape2D.set_deferred("disabled",false)
		nocol=false
	if velocity.length() <= 5:
		moving=false
		animate(lastdir,false,true)
	
