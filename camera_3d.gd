extends Camera3D

func _ready() -> void:
	fov = 75
	near = 0.05
	far = 4000
	position = Vector3(0.0, 0.754, -0.293)
	rotation_degrees = Vector3(0.0, -180.0, 0.0)
