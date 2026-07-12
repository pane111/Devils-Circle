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
	pm = PartyManager.active_members[p_name]
	pm_entity = ResourceManager.get_resource("Entities",p_name) 
	print_debug("Got entity " + str(pm_entity) + " from name "+ p_name)
	%PMName.text = pm_entity.entity_name if !pm.is_player else GameManager.player_name
	var stats = PartyManager.get_finalstats(p_name)
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
	%WpnBtn.text = ResourceManager.get_resource("Equipment",pm.weapon).item_name
	%ArmorBtn.text = ResourceManager.get_resource("Equipment",pm.armor).item_name
	%AccBtn.text = ResourceManager.get_resource("Equipment",pm.acc).item_name
	%DetailPortrait.texture = ptext
	
