extends Area2D

@export var next_scene_path: String
var players: Array[Player]

func _process(_delta):
	pass
	

func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	if player and not players.has(player):
		players.append(player)
	Debug.log(players.size())
	if players.size() == 3:
		change_scene()
		
func change_scene():
	get_tree().change_scene_to_file(next_scene_path)
