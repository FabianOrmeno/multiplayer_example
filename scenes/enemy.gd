class_name Enemy
extends Node2D


@export var max_health: int = 100
@export var speed: float = 50.0
@export var detection_radius: float = 120.0
@export var attack_range: float = 22.0
@export var attack_cooldown: float = 0.8


var health: int
var _cooldown: float = 0.0


func _ready() -> void:
	health = max_health


func take_damage(damage) -> void:
	if not is_multiplayer_authority():
		return

	health -= damage
	Debug.log("Enemy HP: %d" % health)
	if health <= 0:
		die.rpc()

func stun():
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	set_physics_process(true)

@rpc("authority", "call_local", "reliable")
func die() -> void:
	if is_inside_tree():
		queue_free()
		
