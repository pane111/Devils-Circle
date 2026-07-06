extends Area2D
var active=true
func _on_body_entered(body: Node2D) -> void:
	if !active:return
	active=false
	hide()
	$DoorSound.play()
	await $DoorSound.finished
	queue_free()
