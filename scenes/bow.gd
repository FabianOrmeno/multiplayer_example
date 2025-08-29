extends Node2D
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer

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
