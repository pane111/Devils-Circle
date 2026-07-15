extends "res://addons/extra_nodes/sound_button.gd"

@export var pm_name: String
@export var is_player=false
@onready var portrait = $HBoxContainer/Portrait
@onready var hpbar = $HBoxContainer/HPInfo/HPBar
@onready var hpamt = $HBoxContainer/HPInfo/HPAmt
@onready var enbar = $HBoxContainer/EnergyInfo/EnergyBar
@onready var enamt = $HBoxContainer/EnergyInfo/EnergyAmt
var pm_entity: PartyMember
var fstats
func _ready() -> void:
	super._ready()
	load_pm()
	
func set_pm(n_pm_name):
	if !PartyManager.active_members.has(pm_name):
		return
	pm_name = n_pm_name
	is_player = PartyManager.active_members[pm_name].is_player
	
func load_pm():
	if !PartyManager.active_members.has(pm_name):
		print_debug("Could not find party member " + pm_name)
		return
	pm_entity= PartyManager.active_members[pm_name]
	
	text = ResourceManager.get_resource("Entities",pm_entity.base_entity).entity_name if !is_player else GameManager.player_name
	if pm_entity==null:
		print_debug("ERROR: Party Menu failed to load party member " + pm_name)
	
	fstats = await PartyManager.get_finalstats(pm_name)
	portrait.texture=load(pm_entity.portrait)
	var cur_hp = PartyManager.member_states[pm_name]["cur_hp"]
	var max_hp = fstats["hp"]
	hpamt.text = str(roundi(cur_hp))+"/"+str(roundi(max_hp))
	hpbar.value = (cur_hp/max_hp)
	var cur_en = PartyManager.member_states[pm_name]["cur_energy"]
	enbar.value = cur_en
	enamt.text = str(roundi(cur_en))+"/100"
	


func _on_pressed() -> void:
	HudManager.p_menu.show_pd(pm_name,self,portrait.texture)
