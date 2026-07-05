extends Node

@export var lb: Label
@export var slider: Slider
@export var default_label = "Master Volume"
@export var bus: int #0=Master,1=Music,2=SFX,3=Atmo

func _ready() -> void:
	await get_tree().process_frame
	slider.value = AudioServer.get_bus_volume_linear(bus)*100

func _on_slider_value_changed(value: float) -> void:
	#Slider goes from 0 to 100
	AudioServer.set_bus_volume_linear(bus,float(value)/100)
	lb.text = default_label+": "+str(roundi(value))+"%"
