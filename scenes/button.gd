extends Node2D

@onready var area_2d: Area2D = $Area2D

var players = []
var lighted = false

signal state (lighted: bool)

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D):
	var player = body as Player
	if not player:
		player = body as IceCube
	if player:
		Debug.log("Button pusheado")
		players.push_back(player)
		lighted = true
		emit_signal("state",lighted)

func _on_body_exited(body: Node2D):
	players.erase(body)
	Debug.log("Button despusheado")
	if players.is_empty():
		lighted = false
		emit_signal("state",lighted)
