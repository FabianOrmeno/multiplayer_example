class_name Coin
extends Node2D


@export var Value: int = 100

@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	var player = body as Player
	
	if player:
		player.get_coin(self)
		if is_inside_tree():
			queue_free()
