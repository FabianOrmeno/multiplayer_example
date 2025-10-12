class_name Enemy
extends Node2D

@export var max_health: int = 100
@export var speed: float = 50.0
@export var detection_radius: float = 120.0
@export var attack_range: float = 22.0
@export var attack_cooldown: float = 0.8
@onready var remote_healthbar: Healthbar = $RemoteHealthbar
@onready var health_component: HealthComponent = $HealthComponent

@onready var hurtbox = $Hurtbox
var ice: bool = true
var health: int
var _cooldown: float = 0.0
var defeated = false

signal state(defeated)
signal enemy_died(position)

func _ready() -> void:
	health = health_component.max_health
	remote_healthbar.setup(health_component)


func take_damage(damage) -> void:
	if not is_multiplayer_authority():
		return

	health -= damage
	Debug.log("Enemy HP: %d" % health)
	if health <= 0:
		if ice:
			var areas = hurtbox.get_overlapping_areas()
			for area in areas:
				var ball = area as Iceball
				if ball:
					Debug.log("Me mato una bola de hielo :(")
					emit_signal("enemy_died", global_position)
		die.rpc()

func stun():
	set_physics_process(false)
	await get_tree().create_timer(2).timeout
	set_physics_process(true)

@rpc("authority", "call_local", "reliable")
func die() -> void:
	if is_inside_tree():
		emit_signal("state", defeated)
		queue_free()
		
