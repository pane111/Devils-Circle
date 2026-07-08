@icon("uid://dmu6ngw8n4gvw")
class_name Effect
extends Resource

@export var ref_name: String
@export var effect_name:String
@export var effect_desc:String
@export var stat_changes: Dictionary[String,float] #In percentages
@export var can_act=true #Can target act while effect is active
@export var health_change: float
@export var energy_change: float
