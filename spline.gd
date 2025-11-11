extends Node3D
#this is GD script for lates godot version (Nov 2, 2025, V4.4 I think????)
#root for road generation
#use node 3D and attached script, no other nodes needed to funciton, this includes testing for visualiatoin. Implment primitive triangles mesh creation between left and right points.


func create_debug_sphere(position: Vector3, color: Color) -> MeshInstance3D:
	var sphere = MeshInstance3D.new()
	var mesh = SphereMesh.new()
	mesh.radius = 0.15
	mesh.height = 0.3
	sphere.mesh = mesh
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	sphere.material_override = mat
	
	sphere.position = position
	return sphere


#draws the line 
func create_line_visualization(points: Array, color: Color) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	var mesh = ImmediateMesh.new()
	mesh_instance.mesh = mesh
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = color
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mesh_instance.material_override = mat

	mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP)
	for pos in points:
		mesh.surface_add_vertex(pos)
	mesh.surface_end()
	
	return mesh_instance


#generates left and right points to the randomly genrates curves (use this for primitive triangels) 
func generate_offset_points(curve: Curve3D, width: float, step: float = 1.0) -> Dictionary:
	var left_points = []
	var right_points = []
	var total_length = curve.get_baked_length()
	var d = 0.0

	while d <= total_length:
		var tr: Transform3D = curve.sample_baked_with_rotation(d)
		var pos = tr.origin
		
		var right = tr.basis.x.normalized()
		var offset_amount = width / 2.0

		var left_point = pos - right * offset_amount
		var right_point = pos + right * offset_amount
		
		left_points.append(left_point)
		right_points.append(right_point)

		if d + step > total_length and d < total_length:
			d = total_length
		else:
			d += step

	return {"left": left_points, "right": right_points}


#tester floor 
func create_floor(size: float = 100.0):
	var floor = MeshInstance3D.new()
	var plane_mesh = PlaneMesh.new()
	plane_mesh.size = Vector2(size, size)
	floor.mesh = plane_mesh
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.3, 0.3)
	floor.material_override = mat
	var static_body = StaticBody3D.new()
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(size / 2, 0.1, size / 2) # thin floor for physics
	collision.shape = shape
	static_body.add_child(collision)
	floor.add_child(static_body)
	
	add_child(floor)


#creates a curve between two points, start and end, bounded by the floor 
func generate_random_curve(start: Vector3, end: Vector3, bounds: Dictionary,
		num_points: int = 50,
		curve_amplitude: float = 20.0,
		curve_frequency: float = 2.0,
		height_amplitude: float = 3.0,
		bank_amount_degrees: float = 12.0) -> Curve3D:
	
	var curve = Curve3D.new()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var forward = (end - start).normalized()
	var right = forward.cross(Vector3.UP).normalized()
	
	# Smooth varying amplitude & frequency
	var amp_start = curve_amplitude + rng.randf_range(-30.0, 30.0)
	var amp_end   = curve_amplitude + rng.randf_range(-30.0, 30.0)
	
	var freq_start = curve_frequency + rng.randf_range(-0.5, 0.5)
	var freq_end   = curve_frequency + rng.randf_range(-0.5, 0.5)
	
	for i in range(num_points + 1):
		var t = float(i) / num_points
		var pos = start.lerp(end, t)
		
		var amp = lerp(amp_start, amp_end, t)
		var freq = lerp(freq_start, freq_end, t)
		
		# Horizontal curve shape
		var turn_strength = sin(t * PI * freq)
		var sideways = turn_strength * amp
		pos += right * sideways
		
		# Vertical roll
		pos.y += sin(t * PI * freq * 0.5) * height_amplitude
		
		# Clamp inside map bounds
		pos.x = clamp(pos.x, bounds["min"].x, bounds["max"].x)
		pos.y = clamp(pos.y, 0.0, bounds["max"].y)
		pos.z = clamp(pos.z, bounds["min"].z, bounds["max"].z)
		
		curve.add_point(pos)

		
	return curve



func _ready():
	# Define map boundaries
	var map_bounds = {
		"min": Vector3(-75, 0, -75),
		"max": Vector3(75, 50, 75)
	}
	
	create_floor(150.0)
	
	# Step 1: Create a Path3D and attach a random curve within bounds
	var path = Path3D.new()
	add_child(path)
	
	var start = Vector3(-50, 0, -50)
	var end = Vector3(60, 0, 70)
	var curve = generate_random_curve(start, end, map_bounds, 6, 10.0)
	path.curve = curve

	# Step 2: Generate offset points for road edges
	var offsets = generate_offset_points(curve, 6.0, 1.0)
	print("Generated ", offsets["left"].size(), " offset segments")

  #for visualization
	var total_length = curve.get_baked_length()
	var curve_points = []
	var d = 0.0
	while d <= total_length:
		curve_points.append(curve.sample_baked(d))
		d += 1.0
		
	add_child(create_line_visualization(curve_points, Color.RED))
	##this is how it pulls the left and right points for the visualization
	#you should use these points for primitive triangls to create the road mesh 
	for p in offsets["left"]:
		add_child(create_debug_sphere(p, Color.BLUE))
	for p in offsets["right"]:
		add_child(create_debug_sphere(p, Color.GREEN))
		
	add_child(create_line_visualization(offsets["left"], Color.BLUE.darkened(0.4)))
	add_child(create_line_visualization(offsets["right"], Color.GREEN.darkened(0.4)))

	# Camera + Lighting
	#var camera = Camera3D.new()
	#add_child(camera)
	#camera.position = Vector3(0, 80, 150)
	#camera.look_at(Vector3(0, 0, 0), Vector3.UP)

	var light = DirectionalLight3D.new()
	add_child(light)
	light.rotation_degrees = Vector3(-45, 45, 0)
	

	if has_node("CarSimulation/car") and has_node("SpawnArea"):
		var car = get_node("CarSimulation/car")
		var spawn_area = get_node("SpawnArea")
		spawn_area.offsets = offsets
		spawn_area.curve = curve
		spawn_area.setup_spawn_area()
		spawn_area.spawn_car(car)

		
	
	create_road_mesh(offsets)
	create_obstacles(curve,offsets)
	


func create_road_mesh(offsets: Dictionary):
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	#testing material
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.2, 0.2)
	mat.roughness = 1.0
	st.set_material(mat)
	
	var left_points = offsets["left"]
	var right_points = offsets["right"]
	
	for i in range(left_points.size() - 1):
		var l1 = left_points[i]
		var r1 = right_points[i]
		var l2 = left_points[i + 1]
		var r2 = right_points[i + 1]
		
		# Triangle 1
		st.add_vertex(l1)
		st.add_vertex(r1)
		st.add_vertex(r2)
		
		# Triangle 2
		st.add_vertex(l1)
		st.add_vertex(r2)
		st.add_vertex(l2)
	
	st.generate_normals()
	
	var mesh = st.commit()
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	
	# Add collision for driving
	var static_body = StaticBody3D.new()
	var shape = CollisionShape3D.new()
	var shape_resource = ConcavePolygonShape3D.new()
	shape_resource.data = mesh.surface_get_arrays(0)[Mesh.ARRAY_VERTEX]
	shape.shape = shape_resource
	static_body.add_child(shape)
	mesh_instance.add_child(static_body)
	
	add_child(mesh_instance)


func create_obstacles(curve: Curve3D, offsets: Dictionary):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var obstacle_count = 14
	var total_length = curve.get_baked_length()

	for i in range(obstacle_count):
		var d = rng.randf_range(5.0, total_length - 5.0)
		var idx = clamp(int(d), 0, offsets["left"].size() - 1)
		var left_point = offsets["left"][idx]
		var right_point = offsets["right"][idx]
		var t = rng.randf_range(0.2, 0.8)                      #random offset
		var pos = left_point.lerp(right_point, t)

		pos.y += 1.0 + rng.randf_range(0.0, 0.5)

		var obstacle = MeshInstance3D.new()
		var mesh = BoxMesh.new()
		mesh.size = Vector3(2, 2, 2)
		obstacle.mesh = mesh

		var mat_obs = StandardMaterial3D.new()
		mat_obs.albedo_color = Color(0.8, 0.2, 0.2)
		obstacle.material_override = mat_obs
		obstacle.position = pos

		# Add collision
		var body = StaticBody3D.new()
		var shape = CollisionShape3D.new()
		var box_shape = BoxShape3D.new()
		box_shape.size = Vector3(2, 2, 2)
		shape.shape = box_shape
		body.add_child(shape)
		obstacle.add_child(body)

		add_child(obstacle)
		
