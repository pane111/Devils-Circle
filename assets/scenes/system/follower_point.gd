extends Node2D

@export var player: Node2D
@export var sustained_distance=16.0
var angle=0.0
func _process(delta: float) -> void:
	var pdir = player.global_position - self.global_position
	angle=global_position.angle_to_point(player.global_position)
	var pdist = pdir.length()
	var tpos = player.global_position - pdir.normalized() * sustained_distance
	
	if pdist > sustained_distance:
		global_position = tpos
		#global_position=lerp(global_position,tpos,delta*5)
