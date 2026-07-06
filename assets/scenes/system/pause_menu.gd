extends Node


func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and HudManager.active_menu==self:
		AudioManager.play_global_cancel()
		HudManager.set_pause(false)
func _on_close_btn_pressed() -> void:
	HudManager.set_pause(false)

func close_all_submenus():
	%SystemMenu.hide()
	
	HudManager.active_menu=self

func _on_system_btn_pressed() -> void:
	%SystemMenu.show()
	HudManager.active_menu=%SystemMenu
	%CloseSysBtn.grab_focus()


func _on_close_sys_btn_pressed() -> void:
	%SystemMenu.hide()
	HudManager.active_menu=self
	%SystemBtn.grab_focus()


func _on_settings_btn_pressed() -> void:
	HudManager.set_settings(true)
	await HudManager.settings_closed
	%SettingsBtn.grab_focus()


func _on_title_btn_pressed() -> void:
	Input.action_press("menu")
	FlagManager.reset_all_flags()
	GameManager.load_new_scene("uid://csqyyca6875fq",null,true,false)
