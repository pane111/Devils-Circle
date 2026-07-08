extends Node

@export var base_path: String

@export var database: Dictionary = {
	"Entities": {},
	"Items": {},
	"Equipment": {},
	"Skills": {}
}

var category_paths = {
	"Entities": "entities/list/",
	"Items": "items/list/",
	"Equipment": "equipment/list/",
	"Skills": "skills/list/"
}

func _ready():
	for category in category_paths:
		load_category(category, base_path+category_paths[category])

func load_category(category_name: String, path: String):
	var dir = DirAccess.open(path)
	if dir == null:
		printerr("Directory missing for: " + category_name + " at " + path)
		return
		
	dir.list_dir_begin()
	for file: String in dir.get_files():
		
		var stripped_file = file.trim_suffix(".remap").trim_suffix(".import")
		
		if stripped_file.ends_with(".tres"):
			var fpath = path.path_join(stripped_file)
			var res = load(fpath)
			if res and "ref_name" in res:
				database[category_name][res.ref_name] = res
			else:
				print_debug("Could not load resource at " + path)
	
	dir.list_dir_end()
	print("Loaded category: ", category_name, " with ", database[category_name].size(), " items.")

func get_resource(category: String, ref_name: String):
	if database.has(category) and database[category].has(ref_name):
		return database[category][ref_name]
	
	printerr("Resource not found: ", category, "/", ref_name)
	return null
