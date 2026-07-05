@icon("uid://cfepqryur5bej")
class_name CharacterContainer
extends Resource

@export var portraits : SpriteFrames #Will be displayed in dialogue
@export var voice: AudioStream #Plays when typing
@export var display_name: String #Name that will be displayed in dialogue
@export var ref_name: String #Name that will be used to reference this character
@export var display_color = Color.WHITE #Color the character's name will be displayed as
