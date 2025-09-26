extends Node2D

@export var player_scene: PackedScene
@export var dot_scene: PackedScene
@export var mage_scene: PackedScene
@export var warrior_scene: PackedScene
@export var archer_scene: PackedScene
@onready var players: Node2D = $Players
@onready var markers: Node2D = $Markers


func _ready() -> void:
	var count = 0;
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst
		if Statics.get_role_name(player_data.role) == "Guerrero":
			player_inst = warrior_scene.instantiate()
		elif Statics.get_role_name(player_data.role) == "Maga":
			player_inst = mage_scene.instantiate()
		elif Statics.get_role_name(player_data.role) == "Arquero":
			player_inst = archer_scene.instantiate()
		players.add_child(player_inst)
		player_inst.global_position = markers.get_child(i).global_position
		player_inst.setup(player_data)
		player_inst.dot_spawn_requested.connect(_on_dot_spawn)
		count += 1
	await get_tree().create_timer(5).timeout
	Debug.log(get_tree().get_nodes_in_group("player").size())

func _on_dot_spawn(pos):
	spawn_dot.rpc_id(1, pos)
	
@rpc("any_peer", "call_local", "reliable")
func spawn_dot(pos):
	if not dot_scene:
		return
	var dot_inst = dot_scene.instantiate()
	add_child(dot_inst, true)
	dot_inst.global_position = pos
