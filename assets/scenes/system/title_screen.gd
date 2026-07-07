extends Node

#ALWAYS ALWAYS reference scenes that need to be loaded/unloaded a lot via strings
@export var starter_scene: String
@export var title_music: AudioStream
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameManager.cur_scene == null:
		GameManager.cur_scene=self
	AudioManager.play_song(title_music)
	GameManager.reset_pms()
	$CanvasLayer/Panel/VBoxContainer/PlayBtn.grab_focus()

func _on_play_btn_pressed() -> void:
	FlagManager.reset_all_flags()
	GameManager.load_new_scene(starter_scene)


func _on_settings_btn_pressed() -> void:
	HudManager.set_settings(true)
	
	await HudManager.settings_closed
	$CanvasLayer/Panel/VBoxContainer/SettingsBtn.grab_focus()


func _on_quit_btn_pressed() -> void:
	get_tree().quit()


func _on_load_btn_pressed() -> void:
	GameManager.load_data(0)
