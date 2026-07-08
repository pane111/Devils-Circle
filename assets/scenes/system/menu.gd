extends Control

@export var return_to: Node
@export var exit_method: String


func on_open():
	pass

func return_to_prev():
	HudManager.active_menu=return_to
	self.hide()
	if !exit_method.is_empty():
		if return_to.has_method(exit_method):
			return_to.call(exit_method)
	
