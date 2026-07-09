extends Node

var lastpmbtn
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel") and HudManager.active_menu==self:
		AudioManager.play_global_cancel()
		HudManager.set_pause(false)
func _on_close_btn_pressed() -> void:
	HudManager.set_pause(false)

func _ready() -> void:
	close_all_submenus()

func show_pd(pname,btn,portrait_texture):
	if btn != null:
		lastpmbtn = btn
	%PartyDetail.set_pm(pname,portrait_texture)
	%PartyDetail.show()
	HudManager.active_menu=%PartyDetail
	%WpnBtn.grab_focus()
func hide_pd():
	%PartyDetail.hide()
	HudManager.active_menu = %PartyMenu
	lastpmbtn.grab_focus()

func close_all_submenus():
	%SystemMenu.hide()
	%PartyMenu.hide()
	%PartyDetail.hide()
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
	close_all_submenus()
	HudManager.close_all_popups()
	get_tree().paused=false
	FlagManager.reset_all_flags()
	GameManager.load_new_scene("uid://csqyyca6875fq",null,true,false)


func _on_close_party_button_pressed() -> void:
	%PartyMenu.hide()
	%PartyDetail.hide()
	HudManager.active_menu=self
	%PartyBtn.grab_focus()


func _on_party_btn_pressed() -> void:
	%PartyMenu.on_open()
	%PartyMenu.show()
	HudManager.active_menu=%PartyMenu
	%PartyMenu.pm_cont.get_child(0).grab_focus()
