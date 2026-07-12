extends "res://character.gd"
@export var dialogue_start = "start"
@export var dialogue_res: DialogueResource
@export var animate_on_ready=true
@export var look_at_player=true
@export var req_flag: String
@export var req_value = 1

var player
var max_hp=3.0
var cur_hp
signal killed

func _ready() -> void:
	cur_hp=max_hp
	if !req_flag.is_empty() && !FlagManager.check_flag(req_flag,req_value):
		queue_free()
	
	if can_move:
		$RandomMoveTimer.start(randf_range(0.5,3.0))
	else:
		if animate_on_ready:
			animate(lastdir,false,true)
	super._ready()
	
func remove():
	queue_free()

func on_slash():
	
	anim.self_modulate=Color.RED
	var critroll = randi_range(0,100)
	if critroll <= 20:
		EffectManager.spawn_text("[color=orange]2!",self.global_position,false,50.0,0.5)
		cur_hp-=2
	else:
		EffectManager.spawn_text("1",self.global_position,false,50.0,0.5)
		cur_hp-=1
	
	EffectManager.spawn_local_effect("hit",global_position,self)
	var pushdir = global_position - GameManager.player.global_position
	push_char(pushdir.normalized(),0.1,500,true,true)
	await move_completed
	if cur_hp<=0:
		killed.emit()
		GameManager.malice += randf_range(1.0,3.0)
		EffectManager.spawn_local_effect("blood",global_position,self)
		remove()
	else:
		anim.self_modulate=Color.WHITE


func on_interact():
	player = GameManager.player
	var dir=player.global_position-global_position
	can_move=false
	velocity = Vector2.ZERO
	moving=false
	if look_at_player:
		animate(dir.normalized(),false,true)
	if dialogue_res != null:
		DialogueManager.show_dialogue_balloon(dialogue_res,dialogue_start,[self])
		await DialogueManager.dialogue_ended
	else:
		await get_tree().create_timer(0.5)
	
	can_move=true


func _on_random_move_timer_timeout() -> void:
	var rand_dir = Vector2(randi_range(-1,1),randi_range(-1,1))
	move_char(rand_dir,randf_range(0.1,0.6),0.5)
	await move_completed
	$RandomMoveTimer.start(randf_range(0.5,3.0))
