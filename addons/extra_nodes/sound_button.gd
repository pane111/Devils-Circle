extends Button
var selected=false
@export var submit_text=false
signal pressed_text(val: String)
func _ready() -> void:
	gui_input.connect(_on_input)
	if submit_text:
		pressed.connect(on_pressed)
	
func on_pressed():
	pressed_text.emit(text)
func _on_input(input: InputEvent) -> void:
	await get_tree().process_frame
	if !has_focus():
		selected=false
		return
	if !input.is_action("ui_accept") && !selected:
		AudioManager.play_global_select()
		selected=true
	elif input.is_action_pressed("ui_accept"):
		AudioManager.play_global_accept()
