extends Node2D

@onready var multiplayer_synchronizer: MultiplayerSynchronizer = $MultiplayerSynchronizer
@onready var colition_shield: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var hitbox: Hitbox = $Hitbox

var data: Statics.PlayerData = null


func _ready() -> void:
	if data:
		setup(data)
	if is_multiplayer_authority():
		hitbox.area_entered.connect(reflect)


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

func reflect(area: Area2D) -> void:
	Debug.log("area entered")
	var fireball = area as FireBall
	var iceball = area as Iceball
	if fireball:
		var angle = get_angle_to(fireball.global_position)
		fireball.rotate(PI-angle*2)
	elif iceball:
		var angle = get_angle_to(iceball.global_position)
		iceball.rotate(PI - angle*2)	
