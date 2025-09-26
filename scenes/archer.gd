extends Player
class_name Archer

func primary_action():
	Debug.log("Arquero")
	fire_server.rpc_id(1, get_global_mouse_position(), "arrow")
