extends MeshInstance3D



func _ready() -> void:
	# Mesh
	var m := BoxMesh.new()
	m.size = Vector3(50, 1, 50)
	mesh = m

	# Material with triplanar
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load("res://icon.svg")
	mat.uv1_triplanar = true
	material_override = mat

	# Transform
	position = Vector3(-1.41, 6.404, 0.0)
