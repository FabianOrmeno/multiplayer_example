extends Node

@export var door: Node2D
@export var interactables: Array[Node2D]
@export var enemy: Frog

# Lista de antorchas y la puerta
var enemy_defeated = false


func _ready():
	if enemy:
		enemy.connect("state", _on_change_enemy)
	if interactables:
		for interact in interactables:
			interact.connect("state", _on_change_interactables)

# Cada vez que cambia una antorcha
func _on_change_interactables(_lighted: bool):
	check_door()

func _on_change_enemy(_defeated: bool):
	enemy_defeated = true
	check_door()
	
func all_activated():
	for interact in interactables:
		if not interact.lighted:
			return false
	return true

# Revisa si todas las antorchas están encendidas
func check_door():
	if (all_activated() && enemy_defeated):
		open_door()

func open_door():
	door.visible=false
	var collision = door.get_node("StaticBody2D")
	if collision:
		door.process_mode = PROCESS_MODE_DISABLED
	

	
