extends Player
class_name  Mage

func primary_action():
	fire_server.rpc_id(1, get_global_mouse_position())
