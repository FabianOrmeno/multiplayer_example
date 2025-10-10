extends Node

@onready var door: Node2D = $Door
@onready var torch_1: Node2D = $Torch
@onready var torch_2: Node2D = $Torch2

# Lista de antorchas y la puerta
var torches := []


func _ready():
	torches = [ torch_1, torch_2 ]
	for torch in torches:
		torch.connect("state", _on_torch_changed)

# Cada vez que cambia una antorcha
func _on_torch_changed(_is_on: bool):
	check_door()

# Revisa si todas las antorchas están encendidas
func check_door():
	if (torch_1.lighted && torch_2.lighted):
		open_door()

func open_door():
	door.visible=false
	var collision = door.get_node("StaticBody2D")
	if collision:
		door.process_mode = PROCESS_MODE_DISABLED
	

	
