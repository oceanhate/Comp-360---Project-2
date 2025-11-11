extends VehicleWheel3D

func _ready() -> void:
	#position = Vector3(0.874, -0.111, 1.111)
	position = Vector3(-0.9, -0.3, 1.3)
	wheel_radius = 0.4
	suspension_stiffness = 50.0
	damping_compression = 1.9
	damping_relaxation = 2.0
	use_as_steering = true
	use_as_traction = false
