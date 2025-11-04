extends SpotLight3D

func _ready() -> void:
	position = Vector3.ZERO
	rotation_degrees = Vector3(-73.0, -157.8, 149.5)
	light_color = Color(1, 1, 1)
	spot_range = 15.0
	light_energy = 25.0
