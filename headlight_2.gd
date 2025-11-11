extends MeshInstance3D

func _ready() -> void:
	position = Vector3(0.517, 0.292, 1.33)
	rotation_degrees = Vector3(0.3, 91.8, -97)

	var prism := PrismMesh.new()
	prism.size = Vector3(0.25, 0.25, 0.25)
	mesh = prism

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0, 0, 0)
	material_override = mat
