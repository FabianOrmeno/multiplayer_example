class_name Iceball
extends Hitbox


@export var max_speed = 150
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.wait_time = 2
	timer.start()

func _physics_process(delta: float) -> void:
	position += max_speed * transform.x * delta


func should_ignore(hurtbox: Hurtbox) -> bool:
	return hurtbox.owner == get_parent().owner


func _on_timer_timeout() -> void:
	queue_free()
