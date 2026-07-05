extends Node

@export var characters: Dictionary[String,CharacterContainer]
var character_directory="res://addons/character_creator/characters/"
func _ready():
	var dir = DirAccess.open(character_directory)
	if dir == null: printerr("Character directory missing!"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		
		var stripped_file = file.trim_suffix(".remap").trim_suffix(".import")
		
		if stripped_file.ends_with(".tres"):
			var path = character_directory.path_join(stripped_file)
			var res = load(path)
			if res:
				characters[res.ref_name] = res
			else:
				print_debug("Could not load character " + path)
		
		
func get_character(ref_name):
	if !characters.has(ref_name): return null
	return characters[ref_name]		
		
func set_character(ref_name,newchar):
	characters[ref_name] = newchar
