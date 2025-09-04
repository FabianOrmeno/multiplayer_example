class_name Hurtbox
extends Area2D


@export var invulnerability_time: float = 0.2
var _can_take: bool = true


func _ready() -> void:
	if is_multiplayer_authority():
		area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D):
	var hitbox = area as Hitbox

	if hitbox and not hitbox.should_ignore(self):
		if owner and owner.has_method("take_damage"):
			owner.take_damage(hitbox.damage)
			hitbox.damage_dealt.emit()
			_begin_invulnerability()


func _begin_invulnerability() -> void:
	_can_take = false
	await get_tree().create_timer(invulnerability_time).timeout
	_can_take = true
