extends SpotLight3D

func _ready() -> void:
	position = Vector3.ZERO
	rotation_degrees = Vector3(-67.6, -16.7, 10.9)
	light_color = Color(1, 1, 1)
	spot_range = 15.0
	light_energy = 25.0
