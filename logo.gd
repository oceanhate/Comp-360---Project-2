extends MeshInstance3D

func _ready() -> void:
	position = Vector3(0.0, 0.296, 1.438)

	var box := BoxMesh.new()
	box.size = Vector3(0.1, 0.2, 0.01)
	mesh = box

	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load("res://ferrari-logo.png")
	mat.uv1_scale = Vector3(3, 3, 3)
	material_override = mat
