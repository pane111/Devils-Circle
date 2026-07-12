extends Node

var entities: Dictionary[String,Node]

signal tween_complete
func focus_cam_on_entity(e_name):
	var target_entity = entities[e_name]
	if target_entity == null: printerr("Entity"+ e_name + "does not exist!");return
	GameManager.maincam.reparent(target_entity)
	GameManager.maincam.position = Vector2.ZERO

func move_cam_to_position(pos,dur):
	#GameManager.maincam.reparent(GameManager)
	var t = get_tree().create_tween()
	t.tween_property(GameManager.maincam,"global_position",pos,dur)
	await t.finished
	tween_complete.emit()


func reset_cam():
	GameManager.maincam.reparent(GameManager.player)
	GameManager.maincam.position = Vector2.ZERO

# Use this to register an entity to the dictionary
func register_entity(e_name,obj):
	entities[e_name]=obj

#Make an entity (NPC, etc) perform this action
func entity_action(e_name,action,args:Array=[]):
	if not e_name:
		printerr("No entity supplied in action!")
		return
	var target_entity = entities[e_name]
	if target_entity == null: printerr("Entity"+ e_name + "does not exist!");return
	if target_entity.has_method(action):
		return await target_entity.callv(action,args)
	else:
		printerr("Target entity" + e_name + "does not have the action " + action + "!")

func set_entity_visible(e_name,val=true):
	var target_entity = entities[e_name]
	if target_entity == null: printerr("Entity"+ e_name + "does not exist!");return
	target_entity.visible=val

func set_entity_position(e_name,pos):
	var target_entity = entities[e_name]
	if target_entity == null: printerr("Entity"+ e_name + "does not exist!");return
	target_entity.global_position=pos

func delete_entity(e_name,q_free=false):
	var target_entity = entities[e_name]
	entities.erase(e_name)
	if q_free: target_entity.queue_free()
