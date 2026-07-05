@tool
extends EditorPlugin

var dock
func _enable_plugin() -> void:
	add_autoload_singleton("CharacterDatabase","res://addons/character_creator/character_database.gd")
func _disable_plugin() -> void:
	remove_autoload_singleton("CharacterDatabase")


func _enter_tree() -> void:
	pass


func _exit_tree() -> void:
	pass
