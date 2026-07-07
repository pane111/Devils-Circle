extends Node

# The GameManager will handle the main game features.
@onready var player = $Player
@onready var fp = %FollowerPoint
var cur_scene #This is the currently loaded scene. For example, the title screen or whatever level is currently active
@onready var maincam = $MainCam
var is_loading_scene=false
var lscene=""
var party_members: Dictionary[String,int]
signal sprint_on
signal sprint_off
@export var followers: Dictionary[String,Node]
func _ready() -> void:
	load_config()
	player.hide()
	hide_followers()
	player.process_mode=Node.PROCESS_MODE_DISABLED
	await get_tree().process_frame
	CutsceneManager.register_entity("player",player)

func set_sprint(val):
	if val:
		sprint_on.emit()
	else:
		sprint_off.emit()

func load_new_scene(scene_path,door=null,transition=true,has_player=true):
	if is_loading_scene: return
	is_loading_scene=true
	
	if transition:
		HudManager.fade_to_black()
		await HudManager.fade_midpoint
	player.reparent(self)
	load_pms()
	cur_scene.queue_free()
	var new_scene = load(scene_path).instantiate()
	add_sibling(new_scene)
	cur_scene=new_scene
	await get_tree().process_frame
	if transition:
		HudManager.fade_black_out()
	if has_player:
		lscene = scene_path
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
		player.show()
		
		maincam.position_smoothing_enabled=false
		maincam.reparent(player.cam_pivot)
		player.reparent(cur_scene)
		
		player.cam_pivot.position = Vector2.ZERO
		maincam.position=Vector2.ZERO
		
		if !"doors" in cur_scene:
			return
		if door == null:
			door = cur_scene.default_door
		if player != null:
			if cur_scene.doors[door] != null:
				player.global_position = cur_scene.doors[door].global_position
				fp.global_position = player.global_position + Vector2.UP
				load_pms()
			else:
				printerr("Door "+door+ " was null!")
		if transition:
			await HudManager.fade_ended
		#maincam.position_smoothing_enabled=true
	else:
		maincam.reparent(self)
		maincam.position = Vector2.ZERO
		player.process_mode = Node.PROCESS_MODE_DISABLED
		hide_followers()
	is_loading_scene=false

func save_config():
	var config = ConfigFile.new()
	config.set_value("settings", "master_volume",AudioServer.get_bus_volume_linear(0))
	config.set_value("settings", "music_volume",AudioServer.get_bus_volume_linear(1))
	config.set_value("settings", "sfx_volume",AudioServer.get_bus_volume_linear(2))
	
	config.save("user://config.cfg")
	print_debug("Saved configurations")

func load_config():
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	
	if err!=OK:
		AudioServer.set_bus_volume_linear(0,0.5)
		AudioServer.set_bus_volume_linear(1,0.5)
		AudioServer.set_bus_volume_linear(2,0.5)
		return
	
	for sec in config.get_sections():
		AudioServer.set_bus_volume_linear(0,config.get_value(sec,"master_volume"))
		AudioServer.set_bus_volume_linear(1,config.get_value(sec,"music_volume"))
		AudioServer.set_bus_volume_linear(2,config.get_value(sec,"sfx_volume"))
	print_debug("Loaded configurations")

func add_pm(pname):
	party_members[pname]=1
	load_pms()

func load_pms():
	hide_followers()
	fp.reparent(player.get_parent())
	
	for p in party_members:
		if party_members[p] == 1:
			followers[p].set_active(true)
			followers[p].reparent(player.get_parent())
			followers[p].reset_pos()

func reset_pms():
	party_members.clear()
func hide_followers():
	for f in followers:
		followers[f].set_active(false)

func save_data(file_num: int):
	var save_file = FileAccess.open("user://savegame"+str(file_num)+".sav",FileAccess.WRITE)
	var saved_data = {
		"flags":FlagManager.flags,
		"lastscene":lscene,
		"party_members":party_members
	}
	var json_file = JSON.stringify(saved_data)
	if json_file != null:
		save_file.store_string(json_file)
		print_debug("Saved data!")
	else:
		print_debug("Error with JSON string")
	
	save_file.close()

func load_data(file_num: int):
	if not FileAccess.file_exists("user://savegame"+str(file_num)+".sav"):
		print_debug("Invalid savegame name!")
		return
		
	var save_file = FileAccess.open("user://savegame"+str(file_num)+".sav",FileAccess.READ)
	var sf_temp = JSON.parse_string(save_file.get_as_text())
	if sf_temp is Dictionary:
		FlagManager.reset_all_flags()
		var lflags = sf_temp.get("flags",{})
		for key in lflags:
			FlagManager.flags[key] = lflags[key]
		
		var lpm = sf_temp.get("party_members",{})
		for key in lpm:
			party_members[key] = lpm[key]
		lscene = sf_temp["lastscene"]
		load_new_scene(lscene,"shrine")
	else:
		print_debug("Save data could not be parsed")
	save_file.close()
