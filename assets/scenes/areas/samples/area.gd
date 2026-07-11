extends Node2D

@export var area_name: String
@export var area_music: AudioStream
@export var area_music_layer2: AudioStream
@export var doors: Dictionary[String,Node2D] #Basically all places where the player can enter/exit the scene
@export var default_door: String #If no door is provided when loading a scene, it will use this one
@export var is_fake_3d=false
@export var scale_speed=1.0
@export var move_mult=1.0


func _ready() -> void:
	AudioManager.fade_music_out()
	await AudioManager.fade_complete
	AudioManager.set_layer(true)
	AudioManager.set_music(area_music,area_music_layer2)
	AudioManager.fade_music_in()
