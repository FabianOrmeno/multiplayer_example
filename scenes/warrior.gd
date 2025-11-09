extends Player
class_name  Warrior
@onready var shield: Shield = $shield
@onready var cant_attack: bool = false
@onready var info_ui: CanvasLayer = $Control/CanvasLayer

func showInfo():
	info_ui.visible = not info_ui.visible
	
func setup(player_data: Statics.PlayerData, num):
	super.setup(player_data, num)
	shield.setup(player_data)
	shield.hide()
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_multiplayer_authority():
		if Input.is_action_just_pressed("second action"):
			weapon.hide()
			shield.show()
			cant_attack = true
		if Input.is_action_pressed("second action") and Input.is_action_just_pressed("click") and not shield.parrying:
			parry()
		if Input.is_action_just_released("second action"):
			weapon.show()
			shield.hide()
			cant_attack = false
			
			
		shield.rotation = global_position.direction_to(get_global_mouse_position()).angle()

func primary_action():
	if cant_attack:
		return
	swing.rpc()
	Debug.log("guerrero")

func secondary_action():
	shield.rotation = global_position.direction_to(get_global_mouse_position()).angle()
	shield.block()
	
func parry() -> void:
	shield.parry()
