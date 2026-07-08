extends "res://assets/scenes/system/menu.gd"

@onready var pm_cont = $VBoxContainer/PMContainer
@onready var returnbtn = $VBoxContainer/PMContainer/ClosePartyButton
var pm_container_button = "uid://bm0wgrgr0su58"
var pms: Dictionary[String,Node]

func _ready() -> void:
	PartyManager.reset_sig.connect(reset_pms)

func add_pm(pname: String):
	if pms.has(pname): return
	var newpm = load(pm_container_button).instantiate()
	pm_cont.add_child(newpm)
	pm_cont.move_child(returnbtn,pm_cont.get_child_count()-1)
	returnbtn.focus_neighbor_bottom = pm_cont.get_child(0).get_path()
	pm_cont.get_child(0).focus_neighbor_top = returnbtn.get_path()
	newpm.set_pm(pname)
	pms[pname] = newpm
func reset_pms():
	for pm in pms:
		pms[pm].queue_free()
	pms.clear()
func on_open():
	$VBoxContainer/PLevel.text="Party Level: " + str(PartyManager.party_level)
	for c in pm_cont.get_children():
		if c.has_method("load_pm"):
			c.load_pm()
