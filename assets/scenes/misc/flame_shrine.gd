extends StaticBody2D

@export var dialogue_res: DialogueResource

func _ready() -> void:
	if "doors" in get_parent():
		get_parent().doors["shrine"]=$SpawnPoint

func on_interact():
	DialogueManager.show_dialogue_balloon(dialogue_res,"start")
	await DialogueManager.dialogue_ended
	EffectManager.spawn_text("Game saved!",GameManager.player.global_position,false,20,1.5)
	$SaveSound.play()
