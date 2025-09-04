extends Enemy
class_name Frog


@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var hitbox_shape: CollisionShape2D = $Hitbox/CollisionShape2D2

func _ready() -> void:
	super._ready()

	if hitbox_shape:
		hitbox_shape.disabled = true


func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority():
		return

	_cooldown = max(0.0, _cooldown - delta)
	var target := _find_target()

	if target:
		var to_target := global_position.direction_to(target.global_position)
		position += to_target * speed * delta
		playback.travel("idle") # falta animacion walk
		if global_position.distance_to(target.global_position) <= attack_range and _cooldown <= 0.0:
			_do_attack()
			_cooldown = attack_cooldown
	else:
		playback.travel("idle")


func _find_target() -> CharacterBody2D:
	var players_container := get_tree().get_root().find_child("Players", true, false)
	var best: CharacterBody2D = null
	var best_d := INF

	if players_container:
		for child in players_container.get_children():
			if child is CharacterBody2D:
				var d := global_position.distance_to(child.global_position)
				if d < detection_radius and d < best_d:
					best = child
					best_d = d
	return best


func _do_attack() -> void:
	if not hitbox_shape:
		return

	hitbox_shape.disabled = false
	await get_tree().create_timer(0.15).timeout

	if is_instance_valid(hitbox_shape):
		hitbox_shape.disabled = true
		
