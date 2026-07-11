extends Node2D

@export var dist_speed=2.0
@export var min_scale=0.4
@export var max_scale=1.0

@export var objects:Array[Node2D]
var starting_positions:Dictionary[Node2D,Vector2]
var cam_start_pos
func _ready() -> void:
	cam_start_pos = get_viewport().get_camera_2d().global_position
	for o in objects:
		starting_positions[o] = o.global_position

func _process(delta: float) -> void:
	var cam_pos = get_viewport().get_camera_2d().global_position
	var cdif = cam_pos.y - cam_start_pos.y
	self.scale.y = clampf((cdif/500) * dist_speed,min_scale,max_scale)
	for o in objects:
		if o == null:
			objects.erase(o)
			return
		var local_pos = starting_positions[o] - self.global_position
		local_pos.y *= self.scale.y
		o.global_position = self.global_position + local_pos
