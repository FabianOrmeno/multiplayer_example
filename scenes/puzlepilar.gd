extends Node2D

@onready var area_2d: Area2D = $Area2D
@export var raft: Raft

func _ready() -> void:
	area_2d.area_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Area2D):
	if body is Arrow:
		body.queue_free()
		if is_multiplayer_authority():
			raft.start.rpc()
