class_name Healthbar
extends Control


@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


func set_new_value(value):
	texture_progress_bar.value = value
