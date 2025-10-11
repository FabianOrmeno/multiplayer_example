extends RigidBody2D
@onready var hurtbox = $Hurtbox
var max_speed = 100

func _ready() -> void:
	#self.lock_rotation = true
	set_lock_rotation_enabled(true)

	Debug.log("ESTOY AQUI")

func take_damage(damage):
	if not is_multiplayer_authority():
		return
	var areas = hurtbox.get_overlapping_areas()
	for area in areas:
		var warrior = area.get_parent().get_parent() as Warrior
		if warrior:
			Debug.log("ME PEGO EL GUERRERO")
			var direcction = (self.global_position - warrior.global_position).normalized()
			apply_central_impulse(direcction*max_speed)
		var bomb = area.get_parent() as Bomb_arrow
		print(bomb)
		print(area.get_parent())
		if bomb:
			die.rpc()

@rpc("authority", "call_local", "reliable")
func die() -> void:
	if is_inside_tree():
		queue_free()
