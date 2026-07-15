extends Area2D

@export var scene_to_load: String
@export var door: String

func _ready() -> void:
	hide()

func _on_body_entered(body: Node2D) -> void:
	if GameManager.is_loading_scene:
		await HudManager.fade_ended
	GameManager.load_new_scene(scene_to_load,door)
