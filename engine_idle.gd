extends AudioStreamPlayer3D

func _ready() -> void:
	if stream:
		stream.loop = true
	autoplay = false
	volume_db = -25  # original idle sound broke my ears
