extends Node

@export var database: Dictionary = {
	"Entities": {},
	"Items": {},
	"Equipment": {},
	"Skills": {}
}

var category_paths = {
	"Entities": "res://assets/resources/entities/list/",
	"Items": "res://assets/resources/items/list/",
	"Equipment": "res://assets/resources/equipment/list/",
	"Skills": "res://assets/resources/skills/list/"
}

func _ready():
	for category in category_paths:
		load_category(category, category_paths[category])

func load_category(category_name: String, path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		printerr("Directory missing for: " + category_name + " at " + path)
		return
		
	dir.list_dir_begin()
	var file_name = dir.get_next()
	
	while file_name != "":
		if !dir.current_is_dir() and file_name.ends_with(".tres"):
			var full_path = path.path_join(file_name)
			var res = load(full_path)
			
			if res and "ref_name" in res:
				database[category_name][res.ref_name] = res
			else:
				print_debug("Could not load/identify resource at: " + full_path)
				
		file_name = dir.get_next()
	
	dir.list_dir_end()
	print("Loaded category: ", category_name, " with ", database[category_name].size(), " items.")

func get_resource(category: String, ref_name: String):
	if database.has(category) and database[category].has(ref_name):
		return database[category][ref_name]
	
	printerr("Resource not found: ", category, "/", ref_name)
	return null
