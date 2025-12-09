extends Control

@onready var canvas_layer: CanvasLayer = $CanvasLayer

func _ready():
	canvas_layer.visible = false

func _process(_delta):
	return
	# Solo el jugador local debe detectar input
	if not is_multiplayer_authority():
		return

	if Input.is_action_just_pressed("información"):
		toggle_info_panel()

func toggle_info_panel():
	Debug.log("ssdaafasd")
	canvas_layer.visible = not canvas_layer.visible
