class_name Meta
extends Area2D

var players: Array[Player]
signal players_ready

func _ready() -> void:
	body_entered.connect(_new_player)
	body_exited.connect(_player_out)
	

func _new_player(body: Node2D) -> void:
	var player = body as Player
	if player and not players.has(player):
		players.append(player)
	Debug.log(players.size())
	if players.size() == 3:
		players_ready.emit()

func _player_out(body: Node2D) -> void:
	var player = body as Player
	if players.has(player):
		players.erase(player)
