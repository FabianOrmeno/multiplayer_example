class_name HealthComponent
extends MultiplayerSynchronizer

signal health_changed(value)

@export var health = 100:
	set(value):
		health = value
		health_changed.emit(value)

@export var max_health = 100
		
