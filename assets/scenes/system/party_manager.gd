extends Node


@export var party_level=1
@export var active_members: Dictionary[String,PartyMember]
@export var all_members: Dictionary[String,PartyMember]

@export var member_states: Dictionary = {
}

signal reset_sig
func _ready() -> void:
	pass
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
	active_members[pname] = all_members.get(pname)
	if !member_states.has(pname):
		member_states[pname] = {
			"cur_hp": 9999.0,
			"cur_energy": 100.0,
			"weapon": active_members[pname].weapon,
			"armor": active_members[pname].armor,
			"accessory": active_members[pname].acc
		}
	HudManager.add_pm(pname)
	heal_specific_pm(pname)
	

func fully_heal():
	for pm in active_members.keys():
		member_states[pm]["cur_hp"] = get_final_stat("hp",pm)
		member_states[pm]["cur_energy"] = 100.0
func heal_specific_pm(pm):
	member_states[pm]["cur_hp"] = get_final_stat("hp",pm)
	member_states[pm]["cur_energy"] = 100.0


func get_final_stat(stat,pname, is_base = false):
	var pm = active_members[pname]
	var base_entity = ResourceManager.get_resource("Entities",pm.base_entity)
	print_debug("Loaded "+pm.base_entity+" for PM " + pname)
	var stats = base_entity.base_stats
	var levelstats = base_entity.stat_growths
	if !member_states.has(pname):
		print_debug("Member states does not have entry for " + pname)
		return 0.0
	
	var weaponstats = ResourceManager.get_resource("Equipment",member_states[pname]["weapon"]).stat_changes
	var armorstats = ResourceManager.get_resource("Equipment",member_states[pname]["armor"]).stat_changes
	var accstats = ResourceManager.get_resource("Equipment",member_states[pname]["accessory"]).stat_changes
	
	var finalstat =  stats[stat] + (levelstats[stat] * (party_level-1)) + weaponstats[stat] + armorstats[stat] + accstats[stat]
	return finalstat
	
func get_finalstats(pname):
	var pm = active_members[pname]
	var base_entity = ResourceManager.get_resource("Entities",pm.base_entity)
	var stats = base_entity.base_stats
	var levelstats = base_entity.stat_growths
	var finalstats: Dictionary[String,float]
	if !member_states.has(pname):
		print_debug("Member states does not have entry for " + pname)
		return null
	var weaponstats = ResourceManager.get_resource("Equipment",member_states[pname]["weapon"]).stat_changes
	var armorstats = ResourceManager.get_resource("Equipment",member_states[pname]["armor"]).stat_changes
	var accstats = ResourceManager.get_resource("Equipment",member_states[pname]["accessory"]).stat_changes
	
	for stat in stats:
		if levelstats.has(stat):
			finalstats[stat] = stats[stat] + (levelstats[stat] * (party_level-1)) + weaponstats[stat] + armorstats[stat] + accstats[stat]
		else:
			finalstats[stat] = stats[stat]
	return finalstats
