extends Player
class_name Archer

@onready var info_ui: CanvasLayer = $Control/CanvasLayer

func showInfo():
	info_ui.visible = not info_ui.visible

func primary_action():
	Debug.log("Arquero")
	fire_server.rpc_id(1, get_global_mouse_position(), "arrow")
	
func secundary_action():
	Debug.log("Arquero")
	fire_server.rpc_id(1, get_global_mouse_position(), "bomb")
