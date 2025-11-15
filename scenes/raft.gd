class_name Raft
extends Node2D


@export var passengers: Array[Node2D]
@export var time: float = 1
@export var startpoint: Array[Vector2i]
@export var endpoint: Array[Vector2i]
@export var tile_map: TileMapLayer

var initial_position: Vector2
var started = false
var current_time = 0
var dict: Dictionary[Node2D, Node2D] = {}
var can_move :bool = true
var dir = -1

@export var path: Path2D
@onready var top_shape: CollisionShape2D = %TopShape
@onready var bottom_shape: CollisionShape2D = %BottomShape
@onready var right_shape: CollisionShape2D = %RightShape
@onready var left_shape: CollisionShape2D = %LeftShape
@onready var area_2d: Area2D = $Area2D

func _ready() -> void:
	if is_multiplayer_authority():
		area_2d.body_entered.connect(_on_body_entered)
		area_2d.body_exited.connect(_on_body_exited)
	var query_pos = path.curve.sample_baked(0)
	initial_position = global_position - query_pos


func _physics_process(delta: float) -> void:
	if started and is_multiplayer_authority():
		if dir == 1:
			current_time += delta
			if current_time >= time:
				current_time = time
				var curve_length = path.curve.get_baked_length()
				var query_pos = path.curve.sample_baked(curve_length)
				global_position = initial_position + query_pos
				stop.rpc()
			else:
				var curve_length = path.curve.get_baked_length()
				var query = current_time / time * curve_length
				var query_pos = path.curve.sample_baked(query)
				global_position = initial_position + query_pos
		else:
			current_time -= delta
			if current_time <= 0:
				current_time = 0
				var query_pos = path.curve.sample_baked(0)
				global_position = initial_position + query_pos
				stop.rpc()
			else:
				var curve_length = path.curve.get_baked_length()
				var query = current_time / time * curve_length
				var query_pos = path.curve.sample_baked(query)
				global_position = initial_position + query_pos

@rpc("reliable", "call_local")
func start() -> void:
	if started == true:
		return
	started = true
	dir = dir * -1
	if dir == 1:
		left_shape.set_deferred("disabled", false)
		for c in startpoint:
			var atlas_coords = tile_map.get_cell_atlas_coords(c)
			tile_map.set_cell(c, 1, atlas_coords, 0)
	else:
		right_shape.set_deferred("disabled", false)
		for c in endpoint:
			var atlas_coords = tile_map.get_cell_atlas_coords(c)
			tile_map.set_cell(c, 1, atlas_coords, 0)
	add_deferred.call_deferred()

@rpc("reliable", "call_local")
func stop() -> void:
	remove_deferred()
	if dir == 1:
		for c in endpoint:
			var atlas_coords = tile_map.get_cell_atlas_coords(c)
			tile_map.set_cell(c, 1, atlas_coords, 4)
		right_shape.set_deferred("disabled", true)
	else:
		for c in startpoint:
			var atlas_coords = tile_map.get_cell_atlas_coords(c)
			tile_map.set_cell(c, 1, atlas_coords, 4)
		left_shape.set_deferred("disabled", true)
	started = false
	

func _on_body_entered(body: Node2D) -> void:
	if started:
		return
	var player = body as Player
	if player:
		add_passenger.rpc(player.get_path())


func _on_body_exited(body: Node2D) -> void:
	if started:
		return
	var player = body as Player
	if player:
		remove_passenger.rpc(player.get_path())

@rpc("reliable", "call_local")
func add_passenger(node_path: NodePath) -> void:
	if started:
		return
	Debug.log("Entrando")
	var node = get_node(node_path) as Node2D
	if node == null:
		return
	passengers.push_back(node)
	
func add_deferred():
	for passenger in passengers:
		if passenger.get_parent() == self:
			continue
		dict[passenger] = passenger.get_parent()
		passenger.reparent(self)
	

	
@rpc("reliable", "call_local")
func remove_passenger(node_path: NodePath) -> void:
	if started:
		return
	Debug.log("Saliendo")
	var node = get_node(node_path) as Node2D
	passengers.erase(node)

func remove_deferred():
	for passenger in passengers:
		if passenger.get_parent() != self:
			continue
		passenger.reparent(dict[passenger])
