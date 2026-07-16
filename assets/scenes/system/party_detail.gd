extends "res://assets/scenes/system/menu.gd"
var pm: PartyMember
var pm_entity
var stat_names = {
	"hp": "Vitality",
	"str": "Strength",
	"mag": "Magic",
	"def":"Defense",
	"mdf": "MDefense",
	"agi": "Agility",
	"evil": "Malice"
}
var ordered_keys = ["hp","str","mag","def","mdf","agi","evil"]
func set_pm(p_name,ptext):
	if !PartyManager.active_members.has(p_name): return
	pm = PartyManager.active_members[p_name]
	pm_entity = ResourceManager.get_resource("Entities",p_name) 
	print_debug("Got entity " + str(pm_entity) + " from name "+ p_name)
	%PMName.text = pm_entity.entity_name if !pm.is_player else GameManager.player_name
	var stats = await PartyManager.get_finalstats(p_name)
	var stat_string=""
	for key in ordered_keys:
		if pm.is_player:
			if key == "evil":
				stat_string += "Malice: " + str(roundi(GameManager.malice))
			else:
				if stats.has(key):
					stat_string += stat_names[key] + ": " + str(roundi(stats[key])) + "\n"
		else:
			if stats.has(key):
				stat_string += stat_names[key] + ": " + str(roundi(stats[key])) + "\n"
		
	%Stats.text = stat_string
	%WpnBtn.text = ResourceManager.get_resource("Equipment",PartyManager.member_states[p_name]["weapon"]).item_name
	%ArmorBtn.text = ResourceManager.get_resource("Equipment",PartyManager.member_states[p_name]["armor"]).item_name
	%AccBtn.text = ResourceManager.get_resource("Equipment",PartyManager.member_states[p_name]["accessory"]).item_name
	%DetailPortrait.texture = ptext
	


func _on_wpn_btn_pressed() -> void:
	var weapons = InventoryManager.get_weapons_of_type(pm.weapon_type)
	print_debug(str(weapons))
