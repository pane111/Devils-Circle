extends PanelContainer
@export var save_num=0
@onready var btn = $Btn
var lscene_name="???"
var plvl = 1
var player_name="???"
func _ready() -> void:
	GameManager.saved_game.connect(conditional_refresh)
	refresh()

func load_data(file_num: int):
	if not FileAccess.file_exists("user://savegame"+str(file_num)+".sav"):
		return false
	var save_file = FileAccess.open("user://savegame"+str(file_num)+".sav",FileAccess.READ)
	var sf_temp = JSON.parse_string(save_file.get_as_text())
	if sf_temp is Dictionary:
		if sf_temp.has("playername"):
			player_name = sf_temp["playername"]
		else:
			player_name="LOST"
		lscene_name = sf_temp["lastscene_name"] if sf_temp.has("lastscene_name") else "???"
		plvl = roundi(sf_temp["party_level"]) if sf_temp.has("party_level") else 1
	
	else:
		print_debug("Save data could not be parsed")
	save_file.close()
	return true

func conditional_refresh():
	if GameManager.active_file==save_num:
		refresh()

func refresh():
	if load_data(save_num):
		%Portrait.modulate=Color.WHITE
		%PNameLabel.text=player_name
		%PLevelLabel.text="Level "+str(roundi(plvl))
		%PLocationLabel.text=lscene_name
	else:
		%Portrait.modulate=Color.BLACK
		%PNameLabel.text="None"
		%PLevelLabel.text=""
		%PLocationLabel.text=""

func _on_btn_pressed() -> void:
	GameManager.active_file=save_num
	HudManager.save_menu(false)


func _on_btn_focus_entered() -> void:
	%Data.modulate=Color.WHITE


func _on_btn_focus_exited() -> void:
	%Data.modulate=Color(0.485, 0.485, 0.485, 1.0)
