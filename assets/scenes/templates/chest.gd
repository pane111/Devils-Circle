extends StaticBody2D

@export var items: Dictionary[String,int]
@export var i_category="Items"
@onready var anim = $AnimatedSprite2D
var opened=false
var id
func _ready() -> void:
	id = self.get_path()
	if FlagManager.chests.has(id):
		opened=true
		anim.play("opened")
func on_interact():
	if !opened:
		anim.play("open")
		FlagManager.chests[id]=1
		var istring=""
		for item in items:
			var i_res =ResourceManager.get_resource(i_category,item)
			if i_res.is_key:
				InventoryManager.add_item(item,items[item],"keys")
			else:
				if i_category=="Equipment":
					InventoryManager.add_item(item,items[item],"equipment")
				else:
					InventoryManager.add_item(item,items[item],"items")
			
			istring+="Received "+ str(items[item]) + "x " + i_res.item_name+"!\n"
		var resource = DialogueManager.create_resource_from_text("~ cue\n" + istring)
		$ChestOpen.play()
		await anim.animation_finished
		$ItemGet.play()
		DialogueManager.show_dialogue_balloon(resource,"cue",[self])
		
		opened=true
		
	
