extends Node2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var pivot: Node2D = $pivot
@onready var colition_sword: CollisionShape2D = %CollisionShape2D

var data: Statics.PlayerData = null
var swining = false


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
	if swining:
		return
	swining = true
	var tween = create_tween()
	var initial_rotation = global_rotation_degrees
	
	#Activar collision de espada
	colition_sword.disabled = false
	
	tween.tween_property(pivot, "rotation_degrees",  - 70, 0.1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.tween_property(pivot, "rotation_degrees",  20, 0.1).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(pivot, "rotation_degrees", 0, 0.1)
	
	# Desactivar collision de espada con funcion auxiliar
	tween.tween_callback(Callable(self, "_disable_sword_collision"))
	await tween.finished
	swining = false
	

func _disable_sword_collision():
	colition_sword.disabled = true
	
