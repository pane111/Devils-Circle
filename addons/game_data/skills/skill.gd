@icon("uid://ctf3po4vhfwc")
class_name Skill
extends Resource

@export var ref_name: String
@export var skill_name: String
@export var skill_desc: String
@export var power: float #Skill potency would be stat * power
@export var scale_stat: String #Skill scales with the provided stat
@export var energy_cost: float
enum target_type {SINGLE,ALL,RANDOM}
enum default_target {SELF,ENEMY}
enum damage_type {PHYS, MAG}
enum elements {NEUTRAL,FIRE,WATER,NATURE,LIGHT,DARK}
@export var d_type: damage_type
@export var element: elements
@export var target: target_type
@export var def_target: default_target
@export var can_use_in_field=false
@export var grants_effect=false
@export var effect_granted: String
@export var effect_chance=100.0
@export var effect_duration=1
