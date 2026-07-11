extends Control

var text_string=""
@export var characters: String
@onready var letterkey = $VBoxContainer/PanelContainer/GridContainer/LetterKey
@onready var textentry= $VBoxContainer/TextEntry

func _ready() -> void:
	for c in range(0,characters.length()):
		var lk = letterkey.duplicate()
		var ch = characters[c].to_upper()
		if ch == " ":
			ch = "Spc"
		elif ch == "-":
			ch = "Del"
		elif ch == "/":
			ch="Res"
		elif ch=="+":
			ch = "Ok"
		lk.text = ch
		lk.get_child(0).text = ch
		%GridContainer.add_child(lk)

func activate():
	self.show()
	letterkey.grab_focus()

func submit_text():
	%NameLabel.text=text_string.capitalize()
	$ConfirmPopup.show()
	%DenyBtn.grab_focus()
func _on_letter_key_pressed_text(val: String) -> void:
	if val == "Del":
		if text_string.length() > 0:
			text_string = text_string.left(-1)
	elif val == "Spc":
		text_string+=" "
	elif val == "Res":
		text_string=""
	elif val == "Ok":
		if text_string.length() > 0:
			submit_text()
	else:
		text_string+=val
	if text_string.length() > textentry.max_length:
		text_string = text_string.left(textentry.max_length)
	textentry.text=text_string


func _on_deny_btn_pressed() -> void:
	$ConfirmPopup.hide()
	letterkey.grab_focus()


func _on_confirm_btn_pressed() -> void:
	HudManager.confirm_keyboard_entry(text_string.capitalize())
	text_string=""
	textentry.text=""
	$ConfirmPopup.hide()
	self.hide()
