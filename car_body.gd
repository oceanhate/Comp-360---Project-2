extends MeshInstance3D

func _ready() -> void:
	position = Vector3(0.0, -0.071, 0.0)

	# Box body
	var body_mesh := BoxMesh.new()
	body_mesh.size = Vector3(1.5, 0.5, 3.0)
	mesh = body_mesh

	# Red material + hood texture, scaled
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(1, 0, 0, 1) # Red
	mat.albedo_texture = load("res://hood.jpg")
	mat.uv1_scale = Vector3(2.95, 2.95, 2.95)
	material_override = mat
