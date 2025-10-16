extends Node2D

@export var player_scene: PackedScene
@export var dot_scene: PackedScene
@export var mage_scene: PackedScene
@export var warrior_scene: PackedScene
@export var archer_scene: PackedScene
@export var cube_scene: PackedScene
@onready var cube_spawner: MultiplayerSpawner = $CubeSpawner
@onready var players: Node2D = $Players
@onready var markers: Node2D = $Markers
@onready var defeat_screen = $DefeatScreen
@onready var meta: Meta = $Meta
@onready var victory_screen: CanvasLayer = $Victory_screen

var died = 0

func _ready() -> void:
	$Enemy2.connect("enemy_died", spawn_ice)
	defeat_screen.hide()
	victory_screen.hide()
	var count = 0;
	meta.players_ready.connect(_next_level)
	for i in Game.players.size():
		var player_data = Game.players[i]
		var player_inst
		if Statics.get_role_name(player_data.role) == "Guerrero":
			player_inst = warrior_scene.instantiate()
		elif Statics.get_role_name(player_data.role) == "Maga":
			player_inst = mage_scene.instantiate()
		elif Statics.get_role_name(player_data.role) == "Arquero":
			player_inst = archer_scene.instantiate()
		player_inst.connect("died", player_died)
		players.add_child(player_inst)
		player_inst.global_position = markers.get_child(i).global_position
		player_inst.setup(player_data, i)
		player_inst.dot_spawn_requested.connect(_on_dot_spawn)
		player_data.scene = player_inst
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
	
	

func spawn_ice(pos):
	spawn.rpc(pos)
	
@rpc("authority", "call_local", "reliable")
func spawn(pos):
	Debug.log(cube_scene)
	if not cube_scene:
		Debug.log("falta cubito")
		return
	var cube_inst = cube_scene.instantiate()
	cube_inst.global_position = pos
	cube_spawner.add_child(cube_inst, true)

func player_died(id):
	Game.players[id].defeated = true
	var all_defeated = true
	for player in Game.players:
		all_defeated = all_defeated and player.defeated
	if all_defeated:
		defeated.rpc()
		
@rpc("authority", "call_local", "reliable")
func defeated():
	Debug.log("Jajaj, perdieron")
	defeat_screen.show()

@rpc("authority", "call_local", "reliable")
func _next_level() -> void:
	Debug.log("Waos, ganaron")
	victory_screen.show()
	
