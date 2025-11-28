extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

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
	if player and not lighted:
		Debug.log("Button pusheado")
		players.push_back(player)
		lighted = true
		emit_signal("state",lighted)
		playback.travel("press")

func _on_body_exited(body: Node2D):
	players.erase(body)
	Debug.log("Button despusheado")
	if players.is_empty():
		lighted = false
		emit_signal("state",lighted)
		playback.travel("depress")
