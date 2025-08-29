class_name Player
extends CharacterBody2D

signal dot_spawn_requested

@export var max_speed: int = 100
@export var acceleration: int = 800
@export var bullet_scene: PackedScene
@export var weapon_scene: PackedScene

@onready var label: Label = $Label
@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var input_synchronizer: InputSynchronizer = $InputSynchronizer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
@onready var bullet_spawner: MultiplayerSpawner = $BulletSpawner
@onready var sword: Node2D = $Sword
@onready var camera_2d: Camera2D = $Camera2D
@onready var pickable_area_2d: Area2D = $PickableArea2D
@onready var pickable_marker_2d: Marker2D = $PickableMarker2D

var picked_node = null
var pickable: Node2D

var animation_state: String = "idle_"
var animation_direction: String = "down"

func update_sprite_direction(input: Vector2) -> void:
	match input:
		Vector2.DOWN:
			animation_direction = "down"
		Vector2.UP:
			animation_direction = "up"
		Vector2.LEFT:
			animation_direction = "left"
		Vector2.RIGHT:
			animation_direction = "right"

func update_sprite()-> void:
	if velocity.length() > 0:
		animation_state = "move_"
	else:
		animation_state = "idle_"

func _ready() -> void:
	
	if bullet_scene:
		bullet_spawner.add_spawnable_scene(bullet_scene.resource_path)


func _physics_process(delta: float) -> void:

	var move_input = input_synchronizer.move_input
	velocity = velocity.move_toward(move_input * max_speed, acceleration * delta)
	move_and_slide()
	
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("click"):
			self.primary_action()
		sword.rotation = global_position.direction_to(get_global_mouse_position()).angle()
		
	update_sprite_direction(move_input)
	update_sprite()
	playback.travel(animation_state + animation_direction)
	
	#if is_multiplayer_authority():
		#if Input.is_action_just_pressed("click"):
			#dot_spawn_requested.emit(get_global_mouse_position())
		

func setup(player_data: Statics.PlayerData):
	label.text = player_data.name
	name = str(player_data.id)
	set_multiplayer_authority(player_data.id, false)
	multiplayer_synchronizer.set_multiplayer_authority(player_data.id, false)
	input_synchronizer.set_multiplayer_authority(player_data.id, false)
	sword.setup(player_data)
	camera_2d.enabled = is_multiplayer_authority()



@rpc("any_peer", "call_local", "reliable")
func test():
	Debug.log("test: %s" % [label.text] )

@rpc("authority", "call_remote", "unreliable_ordered")
func send_pos(pos):
	position = pos
	

func take_damage(damage: int):
	Debug.log("Auch %d" % damage)

func primary_action():
	Debug.log("Auch")

func secundary_action():
	pass

func fire(pos):
	if not bullet_scene:
		Debug.log("falta la bala")
		return
	var bullet_inst = bullet_scene.instantiate()
	bullet_inst.global_position = global_position
	bullet_inst.global_rotation = global_position.direction_to(pos).angle()
	bullet_spawner.add_child(bullet_inst, true)

@rpc("authority", "call_local", "reliable")
func fire_server(pos):
	fire(pos)

@rpc("authority", "call_local", "reliable")
func swing():
	sword.swing()

func _on_pickable_body_entered(body: Node2D):
	if picked_node:
		return
	if body.is_in_group("Pickable"):
		pickable = body


func _on_pickable_body_exited(body: Node2D):
	if pickable == body:
		pickable = null

@rpc("authority", "call_local", "reliable")
func pick(node_path):
	var node = get_tree().root.get_node(node_path)
	node.get_parent().remove_child(node)
	pickable_marker_2d.add_child(node)
	node.position = Vector2.ZERO
	picked_node = node


@rpc("authority", "call_local", "reliable")
func drop():
	var node = pickable_marker_2d.get_child(0)
	node.get_parent().remove_child(node)
	node.global_position = pickable_marker_2d.global_position
	get_parent().add_child(node)
	picked_node = null
