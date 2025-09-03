extends Enemy
class_name Frog

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]

func _physics_process(delta: float) -> void:
	
	playback.travel("idle")
