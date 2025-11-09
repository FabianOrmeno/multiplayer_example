extends CanvasLayer

@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var main_menu: Button = $MarginContainer/VBoxContainer/Main_menu
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit
@onready var pauser: Label = %Pauser


var pause_owner: bool = false

func _ready() -> void:
	hide()
	resume.pressed.connect(_un_pause)
	main_menu.pressed.connect(_back_main_menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not pause_owner and not get_tree().paused:
			set_pause.rpc(true)
			pause_owner = true
		elif pause_owner and get_tree().paused:
			set_pause.rpc(false)
			pause_owner = false


@rpc("any_peer", "call_local", "reliable")
func set_pause(value: bool) -> void:
	var sender_id = multiplayer.get_remote_sender_id()
	var player_data = Game.get_player(sender_id)
	get_tree().paused = value
	visible = value
	pauser.text = player_data.name

func _un_pause() -> void:
	if pause_owner and get_tree().paused:
		set_pause.rpc(false)
		pause_owner = false

func _back_main_menu() -> void:
	if pause_owner and get_tree().paused:
		set_pause.rpc(false)
		pause_owner = false
		get_tree().change_scene_to_file("res://ui/main_menu.tscn")
	
func _quit() -> void:
	if pause_owner and get_tree().paused:
		set_pause.rpc(false)
		pause_owner = false
		get_tree().quit()
