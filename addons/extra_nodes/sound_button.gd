extends Button
var selected=false

func _ready() -> void:
	gui_input.connect(_on_input)
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
