extends Node2D

@export var typewriter=false
@export var duration=3.0
@export var rise_speed=50.0

func set_text(val):
	$Label.text = val

func _ready() -> void:
	if typewriter:
		$Label.visible_ratio=0
		var tween = get_tree().create_tween()
		tween.tween_property($Label,"visible_ratio",1.0,0.5)
		await tween.finished
	await get_tree().process_frame
	await get_tree().create_timer(duration).timeout
	queue_free()

func _process(delta: float) -> void:
	global_position += Vector2.UP * rise_speed * delta
