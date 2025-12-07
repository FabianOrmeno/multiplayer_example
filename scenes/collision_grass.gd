extends TileMapLayer

@export var segment_height := 600
var player: Node2D

func _ready():
	# Escucha cuando el spawner cree jugadores
	var spawner = get_node("../Players/MultiplayerSpawner") # ajusta la ruta según tu jerarquía
	spawner.spawned.connect(_on_player_spawned)
	

func _on_player_spawned(new_player):
	# Solo seguir al jugador local (importantísimo en multiplayer)
	if new_player.is_multiplayer_authority():
		player = new_player


func _process(_delta):
	if player == null:
		return

	if player.global_position.y < global_position.y - segment_height:
		global_position.y -= segment_height
