extends Hitbox
class_name  Bomb_arrow

@onready var area_2d: Area2D = $Area2D
@onready var arrow = $Sprite2D
@onready var kaboom = $Sprite2D2
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var anim_player = $AnimationPlayer
@export var max_speed = 250


func _ready() -> void:
	kaboom.hide()
	area_2d.hide()
	damage_dealt.connect(explosion.rpc)

func _physics_process(delta: float) -> void:
	position += max_speed * transform.x * delta


func should_ignore(hurtbox: Hurtbox) -> bool:
	return hurtbox.owner == get_parent().owner

@rpc("authority", "reliable", "call_local")
func explosion():
	kaboom.show()
	arrow.hide()
	area_2d.show()
	area_2d.monitoring = true
	if area_2d.has_overlapping_areas():
		var areas = area_2d.get_overlapping_areas()
		for area in areas:
			var enemy = area.get_parent() as Enemy
			if enemy:
				enemy.stun()
		
	set_physics_process(false)
	playback.travel("explosion")
	if is_multiplayer_authority():
		await get_tree().create_timer(0.93).timeout
		queue_free()

func _on_body_entered(body: Node2D):
	var enemy = body as Enemy
	if enemy:
		Debug.log("Voy a stunearte")
		enemy.stun()
		
