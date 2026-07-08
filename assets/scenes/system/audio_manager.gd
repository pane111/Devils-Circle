extends Node

@onready var layer1=$MusicLayer1
@onready var layer2=$MusicLayer2
@export var global_ui_accept_sound: AudioStream
@export var global_ui_cancel_sound: AudioStream
@export var global_ui_select_sound: AudioStream
var c_layer #Current Layer
var i_layer #Inactive Layer
var max_volume=0.0
var paused_progress
signal fade_complete

func _ready() -> void:
	c_layer=layer1
	i_layer=layer2
	max_volume=layer1.volume_linear
	
func _enter_tree() -> void:
	pass
	#get_tree().node_added.connect(_on_node_added)
func _on_node_added(node:Node) -> void:
	if node is Button:
		node.focus_entered.connect(play_global_select)
		node.pressed.connect(play_global_accept)

func set_music(l1,l2):
	layer1.stream=l1
	layer2.stream=l2
	layer1.play()
	layer2.play()
	
func pause_song():
	paused_progress=c_layer.get_playback_position()
	layer1.stop()
	layer2.stop()

func resume_song():
	layer1.play(paused_progress)
	layer1.play(paused_progress)
	fade_music_in()

func play_song(song,progress=0.0):
	set_layer(true)
	layer1.stream=song
	layer1.play(progress)
	layer2.play(progress)

func play_global_accept():
	play_hud_sfx(global_ui_accept_sound)
func play_global_cancel():
	play_hud_sfx(global_ui_cancel_sound)
func play_global_select():
	play_hud_sfx(global_ui_select_sound)
func set_layer(val):
	var stored_vol_1 = c_layer.volume_linear
	var stored_vol_2 = i_layer.volume_linear
	if val:
		c_layer=layer1
		i_layer=layer2
	else:
		c_layer=layer2
		i_layer=layer1
	c_layer.volume_linear=stored_vol_1
	i_layer.volume_linear=stored_vol_2

func fade_music_in(dur=0.5):
	var t = get_tree().create_tween()
	t.tween_property(c_layer,"volume_linear",max_volume,dur)
	await t.finished
	fade_complete.emit()

func fade_music_out(dur=0.5):
	var t = get_tree().create_tween()
	t.tween_property(c_layer,"volume_linear",0.0,dur)
	await t.finished
	fade_complete.emit()



func play_hud_sfx(sfx):
	$HudSFX.stream=sfx
	$HudSFX.play()
