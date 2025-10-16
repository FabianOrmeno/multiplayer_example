extends Enemy

func _ready() -> void:
	health = INF

func stun():
	queue_free()
