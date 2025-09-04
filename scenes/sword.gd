extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var colition_sword: CollisionShape2D = $Hitbox/CollisionShape2D

var data: Statics.PlayerData = null


func _ready() -> void:
	if data:
		setup(data)


func setup(player_data: Statics.PlayerData):
	if data:
		return
	if is_node_ready():
		multiplayer_synchronizer.set_multiplayer_authority(player_data.id, false)
	else:
		data = player_data


func swing():
	var tween = create_tween()
	var initial_rotation = global_rotation_degrees
	
	#Activar collision de espada
	colition_sword.disabled = false
	
	tween.tween_property(self, "global_rotation_degrees", initial_rotation - 70, 0.1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_rotation_degrees", initial_rotation + 20, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_rotation_degrees", initial_rotation, 0.1)
	
	# Desactivar collision de espada con funcion auxiliar
	tween.tween_callback(Callable(self, "_disable_sword_collision"))
	

func _disable_sword_collision():
	colition_sword.disabled = true
	
