extends StaticBody3D

var offsets: Dictionary
var curve: Curve3D
var road_thickness: float = 0.3

func setup_spawn_area():
	#Calculating spawn point
	var left_start = offsets["left"][0]
	var right_start = offsets["right"][0]
	var mid_start = (left_start + right_start) * 0.5
	global_position = mid_start
	global_position.y += road_thickness / 2  	#lift slightly to prevent clipping

	#Determine road width
	var road_width = (right_start - left_start).length()
	
	var mesh_instance = MeshInstance3D.new()
	var cube_mesh = BoxMesh.new()
	cube_mesh.size = Vector3(road_width, road_thickness, road_width)
	mesh_instance.mesh = cube_mesh

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.2)
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mesh_instance.material_override = mat
	add_child(mesh_instance)

	#Adding collision
	var collision = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(road_width, 2.0, road_width)  # 2 units tall
	collision.shape = box_shape
	add_child(collision)

func spawn_car(car_node: Node3D) -> void:
	var left_start = offsets["left"][0]
	var right_start = offsets["right"][0]
	var mid_start = (left_start + right_start) * 0.5
	
	#Car Placement
	car_node.global_position = mid_start + Vector3(0, 5, 0)

	#Orient along track
	var look_target = offsets["left"][5].lerp(offsets["right"][5], 0.5)
	var forward = (look_target - mid_start).normalized()
	car_node.look_at(mid_start + forward * 10, Vector3.UP)

	#Reset physics
	if car_node is RigidBody3D:
		car_node.linear_velocity = Vector3.ZERO
		car_node.angular_velocity = Vector3.ZERO

	#Was having a nightmare trying to spawn the car without it clipping, so for debug
	print("Spawn Y:", global_position.y)
	print("Car Spawned at:", car_node.global_position)
	
