extends Hitbox

@export var max_speed = 250
func _ready() -> void:
	damage_dealt.connect(explosion)

func _physics_process(delta: float) -> void:
	position += max_speed * transform.x * delta


func should_ignore(hurtbox: Hurtbox) -> bool:
	return hurtbox.owner == get_parent().owner

func explosion():
	queue_free()
