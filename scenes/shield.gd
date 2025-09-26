extends Node2D

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var colition_shield: CollisionShape2D = $Hitbox/CollisionShape2D

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


func block():
	#Activar collision de espada
	colition_shield.disabled = false
	
	

func _disable_sword_collision():
	colition_shield.disabled = true
	
