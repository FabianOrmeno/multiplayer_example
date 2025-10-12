extends Node2D


@onready var area_2d: Area2D = $Area2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]


var lighted = false
const Fireball = preload("uid://bvnrvo0kyen53")

signal state (lighted: bool)


func _ready() -> void:
	area_2d.area_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Area2D):
	if body is Fireball:
		lighted = true
		playback.travel("motion")
		emit_signal("state",lighted)
