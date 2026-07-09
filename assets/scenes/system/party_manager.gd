extends Node


@export var party_level=1
@export var active_members: Dictionary[String,PartyMember]
@export var all_members: Dictionary[String,PartyMember]

@export var member_states: Dictionary = {
}

signal reset_sig
func _ready() -> void:
	reset_all()
func reset_all():
	active_members.clear()
	member_states.clear()
	reset_sig.emit()
	add_pm("protag")
	party_level=1

func level_up():
	if party_level < 100:
		party_level+=1
		fully_heal()

func add_pm(pname: String):
	active_members[pname] = all_members[pname]
	var max_hp = get_final_stat("hp",pname)
	member_states[pname] = {
		"cur_hp": max_hp,
		"cur_energy": 100.0
	}
	HudManager.add_pm(pname)
	

func fully_heal():
	for pm in active_members.keys():
		member_states[pm]["cur_hp"] = get_final_stat("hp",pm)
		member_states[pm]["cur_energy"] = 100.0

func get_final_stat(stat,pname):

	var pm = active_members[pname]
	var base_entity = ResourceManager.get_resource("Entities",pm.base_entity)
	print_debug("Loaded "+pm.base_entity+" for PM " + pname)
	var stats = base_entity.base_stats
	var levelstats = base_entity.stat_growths
	var weaponstats = ResourceManager.get_resource("Equipment",pm.weapon).stat_changes
	var armorstats = ResourceManager.get_resource("Equipment",pm.armor).stat_changes
	var accstats = ResourceManager.get_resource("Equipment",pm.acc).stat_changes
	
	var finalstat =  stats[stat] + (levelstats[stat] * (party_level-1)) + weaponstats[stat] + armorstats[stat] + accstats[stat]
	return finalstat
	
func get_finalstats(pname):

	var pm = active_members[pname]
	var base_entity = ResourceManager.get_resource("Entities",pm.base_entity)
	var stats = base_entity.base_stats
	var levelstats = base_entity.stat_growths
	var finalstats: Dictionary[String,float]
	var weaponstats = ResourceManager.get_resource("Equipment",pm.weapon).stat_changes
	var armorstats = ResourceManager.get_resource("Equipment",pm.armor).stat_changes
	var accstats = ResourceManager.get_resource("Equipment",pm.acc).stat_changes
	for stat in stats:
		finalstats[stat] = stats[stat] + (levelstats[stat] * (party_level-1)) + weaponstats[stat] + armorstats[stat] + accstats[stat]
	return finalstats
