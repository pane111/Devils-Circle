@icon("uid://dp7lo1jxdi4rm")
class_name Equipment
extends Item

@export var stat_changes: Dictionary[String,float] = {
	"hp":0.0,
	"str":0.0,
	"mag":0.0,
	"def":0.0,
	"mdf":0.0,
	"agi":0.0
}
@export var teach_skill: String
