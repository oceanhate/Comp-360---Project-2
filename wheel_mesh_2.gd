extends MeshInstance3D

func _ready() -> void:
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.4
	cyl.bottom_radius = 0.4
	cyl.height = 0.25
	cyl.radial_segments = 12
	mesh = cyl

	rotation_degrees = Vector3(0, 0, 90)

	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0, 0, 0) # tire black
	material_override = mat
