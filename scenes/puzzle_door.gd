extends Node

@onready var door: Node2D = $Door
@onready var torch_1: Node2D = $Torch
@onready var torch_2: Node2D = $Torch2
@onready var enemy: Frog = $"../Enemy2"

# Lista de antorchas y la puerta
var torches := []
var enemy_defeated = false


func _ready():
	enemy.connect("state", _on_change_enemy)
	torches = [ torch_1, torch_2 ]
	for torch in torches:
		torch.connect("state", _on_change_torchs)

# Cada vez que cambia una antorcha
func _on_change_torchs(_lighted: bool):
	check_door()

func _on_change_enemy(_defeated: bool):
	enemy_defeated = true
	check_door()
	

# Revisa si todas las antorchas están encendidas
func check_door():
	if (torch_1.lighted && torch_2.lighted && enemy_defeated):
		open_door()

func open_door():
	door.visible=false
	var collision = door.get_node("StaticBody2D")
	if collision:
		door.process_mode = PROCESS_MODE_DISABLED
	

	
