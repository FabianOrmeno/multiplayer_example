extends Player
class_name Archer

@onready var info_ui: CanvasLayer = $Control/CanvasLayer
@onready var arrow_couldown: Timer = %arrow_couldown
@onready var bomb_arrow_couldown: Timer = %bomb_arrow_couldown

func _ready() -> void:
	super._ready()
	arrow_couldown.timeout.connect(func(): arrow_couldown.stop())
	bomb_arrow_couldown.timeout.connect(func(): bomb_arrow_couldown.stop())
	

func showInfo():
	info_ui.visible = not info_ui.visible

func primary_action():
	if not arrow_couldown.is_stopped():
		return
	arrow_couldown.start()
	Debug.log("Arquero")
	fire_server.rpc_id(1, get_global_mouse_position(), "arrow")
	
func secundary_action():
	if not bomb_arrow_couldown.is_stopped():
		return
	bomb_arrow_couldown.start()
	Debug.log("Arquero")
	fire_server.rpc_id(1, get_global_mouse_position(), "bomb")
