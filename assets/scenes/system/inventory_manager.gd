extends Node

@export var inventory: Dictionary = {
	"items":{},
	"equipment":{},
	"keys":{}
}

func get_item_amount(category,key):
	if inventory[category].has(key):
		return int(inventory[category][key])
	else:
		return 0
func has_item(category,key):
	if get_item_amount(category,key) != 0:
		return true
	else: return false
func add_item(ref,amt,type):
	inventory[type][ref]=get_item_amount(type,ref)+amt
func remove_item(ref,type):
	inventory[type][ref] = inventory[type][ref] - 1
	if inventory[type][ref] <= 0:
		inventory[type].erase(ref)
func reset_inventory():
	inventory.clear()
	inventory = {
	"items":{},
	"equipment":{},
	"keys":{}
	}
func get_category(category: String):
	return inventory[category]
func get_weapons_of_type(wtype: int):
	var items = {}
	for item in inventory["equipment"]:
		if get_item_amount("equipment",item) != 0:
			var it_res: Weapon = ResourceManager.get_resource("Equipment",item)
			if it_res.type==wtype:
				items[item]=it_res.item_name
	return items
