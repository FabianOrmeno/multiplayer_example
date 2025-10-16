class_name RemoteHealthBar
extends Control

@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func setup(health_component: HealthComponent):
	texture_progress_bar.value = health_component.health
	texture_progress_bar.max_value = health_component.max_health
	health_component.health_changed.connect(func(value): texture_progress_bar.value = value)
