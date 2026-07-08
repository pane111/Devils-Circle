extends Node

@export var flags: Dictionary[String,int]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func check_flag(f,val):
	if !flag_exists(f):
		set_flag(f,0)
	if flags[f] == val:
		return true
	else:
		return false

func flag_exists(f):
	return flags.has(f)

func set_flag(f,val):
	flags[f]=val

func reset_all_flags():
	flags.clear()
	GameManager.player_name="???"
	PartyManager.reset_all()
