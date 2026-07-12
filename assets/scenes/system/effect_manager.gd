extends Node

@export var effects : Dictionary[String,PackedScene]
@onready var screen_effects = $ScreenEffects
@onready var world_effects=$WorldEffects
var texteffect = preload("uid://babbltks7fiea")
#Spawn something in the world
func spawn_world_effect(eff,pos):
	var new_eff = effects[eff].instantiate()
	new_eff.global_position = pos
	world_effects.add_child(new_eff)
	

#Spawn something on a canvas layer
func spawn_screen_effect(eff,pos):
	var new_eff = effects[eff].instantiate()
	screen_effects.add_child(new_eff)
	new_eff.global_position = pos

func spawn_local_effect(eff,pos,obj):
	var new_eff = effects[eff].instantiate()
	new_eff.global_position = pos
	obj.add_sibling(new_eff)
	



func spawn_text(val,pos,typewriter=false,speed=0.0,duration=3.0):
	var new_eff = texteffect.instantiate()
	
	new_eff.global_position = pos
	GameManager.cur_scene.add_child(new_eff)
	new_eff.set_text(val)
	new_eff.typewriter=typewriter
	new_eff.rise_speed=speed
	new_eff.duration=duration

func spawn_text_on_obj(val,obj,typewriter=false,speed=0.0,duration=3.0):
	var new_eff = texteffect.instantiate()
	obj.add_child(new_eff)
	new_eff.set_text(val)
	new_eff.typewriter=typewriter
	new_eff.rise_speed=speed
	new_eff.duration=duration

func clear_world_effects():
	for c in world_effects.get_children():
		world_effects.remove_child(c)
		c.queue_free()

func clear_screen_effects():
	for c in screen_effects.get_children():
		screen_effects.remove_child(c)
		c.queue_free()

func clear_all_effects():
	clear_world_effects()
	clear_screen_effects()
