extends Player
class_name  Mage

@export var second_bullet_scene: PackedScene
@onready var info_ui: CanvasLayer = $Control/CanvasLayer
@onready var fire_couldown: Timer = %fire_couldown
@onready var freezze_couldown: Timer = %freezze_couldown

func _ready() -> void:
	super._ready()
	fire_couldown.timeout.connect(func(): fire_couldown.stop())
	freezze_couldown.timeout.connect(func(): freezze_couldown.stop())

func showInfo():
	info_ui.visible = not info_ui.visible
	
func primary_action():
	if not fire_couldown.is_stopped():
		return
	fire_couldown.start()
	Debug.log("maguito")
	fire_server.rpc_id(1, get_global_mouse_position(), "fire")

func secundary_action():
	if not freezze_couldown.is_stopped():
		return
	freezze_couldown.start()
	Debug.log("maguito")
	fire_server.rpc_id(1, get_global_mouse_position(), "ice")
