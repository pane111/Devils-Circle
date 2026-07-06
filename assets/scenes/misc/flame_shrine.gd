extends StaticBody2D

func _ready() -> void:
	if "doors" in get_parent():
		get_parent().doors["shrine"]=$SpawnPoint

func on_interact():
	GameManager.save_data(0)
	$SaveSound.play()
