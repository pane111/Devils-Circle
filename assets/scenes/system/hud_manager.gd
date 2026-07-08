extends Node

signal fade_midpoint
signal fade_ended
@export var fade_from_black_at_launch=false
signal settings_closed
var active_menu: Node
func _ready() -> void:
	if fade_from_black_at_launch:
		fade_black_out()
	close_all_popups()

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("menu") and GameManager.player.process_mode!=ProcessMode.PROCESS_MODE_DISABLED:
		set_pause(!get_tree().paused)
		if %SettingsMenu.visible:
			set_settings(false)
	if Input.is_action_just_pressed("ui_cancel"):
		if %SettingsMenu.visible:
			AudioManager.play_global_cancel()
			set_settings(false)
			return
		if active_menu != null && active_menu.has_method("return_to_prev"):
			active_menu.call("return_to_prev")
			#AudioManager.play_global_cancel()
			
func add_pm(pname):
	%PartyMenu.add_pm(pname)
	
func close_all_popups():
	for c in $PopupMenus.get_children():
		c.hide()

func fade_to_black(cont=false):
	$Overlays/FadeBlackAnim.play("fade_to_black")
	await $Overlays/FadeBlackAnim.animation_finished
	fade_midpoint.emit()
	if cont:
		fade_black_out()

func fade_black_out():
	$Overlays/FadeBlackAnim.play("fade_black_out")
	await $Overlays/FadeBlackAnim.animation_finished
	fade_ended.emit()

func set_settings(val):
	if val:
		$PopupMenus/SettingsMenu.show()
		%MasterSlider.grab_focus()
	else:
		GameManager.save_config()
		settings_closed.emit()
		$PopupMenus/SettingsMenu.hide()
		
func set_pause(val):
	if val:
		get_tree().paused=true
		%PauseMenu.show()
		active_menu=%PauseMenu
		%InvBtn.grab_focus()
	else:
		get_tree().paused=false
		AudioManager.play_global_cancel()
		%PauseMenu.close_all_submenus()
		active_menu=%PauseMenu
		%PauseMenu.hide()

func _on_close_settings_pressed() -> void:
	set_settings(false)
