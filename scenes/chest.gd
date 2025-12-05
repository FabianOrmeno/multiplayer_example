extends Node2D


@onready var animation_player = $AnimationPlayer

func open():
	animation_player.play("opening")
	return
