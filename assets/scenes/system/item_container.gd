extends "res://addons/extra_nodes/sound_button.gd"

var item: Item
var category: String
func set_item(new_i,new_c):
	item = new_i
	category=new_c
	text=item.item_name + " x" + str(InventoryManager.get_item_amount(category,item.ref_name))
