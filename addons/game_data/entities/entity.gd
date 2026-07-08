@icon("uid://bkl65cuj0mvb3")
class_name Battle_Entity
extends Resource

@export var ref_name: String
@export var entity_name: String
@export var entity_desc: String
@export var base_stats = {
	"hp":10.0,
	"str":1.0,
	"mag":1.0,
	"def":1.0,
	"mdf":1.0,
	"agi":1.0
}
@export var stat_growths = { #Stats increase by this per level
	"hp":3.0,
	"str":1.0,
	"mag":1.0,
	"def":1.0,
	"mdf":1.0,
	"agi":1.0
}
@export var elemental_defs = { #Multiply elemental damage by these numbers
	"neutral":1.0,
	"fire":1.0,
	"water":1.0,
	"nature":1.0,
	"light":1.0,
	"dark":1.0
}
@export var learnset: Dictionary[int,String] #At level, learn skill
