extends Node2D

@onready var area_2d: Area2D = $Area2D

var lighted = false
const Fireball = preload("uid://bvnrvo0kyen53")


func _ready() -> void:
	area_2d.area_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Area2D):
	if body is Fireball:
		body.queue_free()
