extends Player
class_name  Mage

@export var second_bullet_scene: PackedScene

func primary_action():
	Debug.log("maguito")
	fire_server.rpc_id(1, get_global_mouse_position(), "fire")

func secundary_action():
	Debug.log("maguito")
	fire_server.rpc_id(1, get_global_mouse_position(), "ice")
