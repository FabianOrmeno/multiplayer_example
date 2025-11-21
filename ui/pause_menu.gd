extends CanvasLayer

@onready var resume: Button = $MarginContainer/VBoxContainer/Resume
@onready var main_menu: Button = $MarginContainer/VBoxContainer/Main_menu
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit
@onready var pauser: Label = %Pauser
@onready var yes: Button = %yes
@onready var no: Button = %no
@onready var quit_: MarginContainer = %"Quit?"
@onready var label_quit: Label = %label_quit



var number_vote = 0
var pause_owner: bool = false
var action = "main"


func _ready() -> void:
	hide()
	
	resume.pressed.connect(_un_pause)
	main_menu.pressed.connect(_back_main_menu)
	quit.pressed.connect(_quit)
	yes.pressed.connect(vote_yes)
	no.pressed.connect(vote_no)
	Game.vote_updated.connect(finish_vote)

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
		change_next.rpc("main")
		action = "main"
		show_quit.rpc(true)
	
func _quit() -> void:
	if pause_owner and get_tree().paused:
		change_next.rpc("quit")
		action = "quit"
		show_quit.rpc(true)

@rpc("any_peer", "call_local", "reliable")
func show_quit(value) -> void:
	quit_.visible = value

func vote_yes() -> void:
	Game.set_current_player_vote(true)
	
func vote_no() -> void:
	Game.set_current_player_vote(false)

func finish_vote(id) -> void:
	var players = Game.players
	var all_true = true
	if pause_owner:
		number_vote += 1
	
	for player in players:
		if not player.vote:
			all_true = false
			
	if all_true and pause_owner and number_vote == 3:
		Game.reset_votes()
		set_pause.rpc(false)
		pause_owner = false
		all_quit.rpc(action)
	elif pause_owner and number_vote == 3:
		Game.reset_votes()
		number_vote = 0
		show_quit.rpc(false)
		

@rpc("any_peer", "call_local", "reliable")
func all_quit(next_action: String) -> void:
	if next_action == "main":
		Debug.log("Returning main menu...")
		Lobby.go_to_menu()
	elif next_action == "quit":
		Debug.log("Quiting...")
		get_tree().quit()
		

@rpc("any_peer", "call_local", "reliable")
func change_next(name: String) -> void:
	if name == "main":
		label_quit.text = "back to main menu?"
	if name == "quit":
		label_quit.text = "quit?"
