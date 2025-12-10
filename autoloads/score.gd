extends Node

@onready var player_score: Label = %PlayerScore
var score: int = 0

func _ready() -> void:
	player_score.hide()

func show_score() -> void:
	player_score.show()

func hide_score() -> void:
	player_score.hide()


func update_score(add: int) -> void:
	
	score += add
	var new_score = "Score: " + str(score)
	player_score.text = new_score
