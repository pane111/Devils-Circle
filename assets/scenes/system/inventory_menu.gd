extends "res://assets/scenes/system/menu.gd"

var i_container = preload("uid://dp7xdx66vqc2o")
var lastbtn
var in_list=false
func on_open():
	%ItemsBtn.grab_focus()
	clear_list()
func clear_list():
	for c in %ItemList.get_children():
		c.queue_free()

func return_to_prev():
	clear_list()
	if in_list:
		lastbtn.grab_focus()
		AudioManager.play_global_cancel()
		in_list=false
		return
	in_list=false
	
	super.return_to_prev()
func _on_close_inv_btn_pressed() -> void:
	return_to_prev()

func make_list(category:String):
	clear_list()
	var items = InventoryManager.get_category(category)
	var rm_cat = "Equipment" if category=="equipment" else "Items"
	if items.size() < 1:
		return
		
	for i in items:
		var nc = i_container.instantiate()
		nc.set_item(ResourceManager.get_resource(rm_cat,i),category)
		%ItemList.add_child(nc)
	%ItemList.get_child(0).grab_focus()
	in_list=true

func _on_items_btn_pressed() -> void:
	lastbtn = %ItemsBtn
	make_list("items")
	
	


func _on_equipment_btn_pressed() -> void:
	lastbtn = %EquipmentBtn
	make_list("equipment")


func _on_keys_btn_pressed() -> void:
	lastbtn = %KeysBtn
	make_list("keys")
