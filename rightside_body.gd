extends MeshInstance3D

func _ready() -> void:
	position = Vector3(-0.73, 0.243, 0.584)
	rotation_degrees = Vector3(-89.7, 0, 0)

	var cap := CapsuleMesh.new()
	cap.radius = 0.03
	cap.height = 1.8
	mesh = cap

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0, 0, 0) # black
	material_override = mat
