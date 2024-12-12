extends MeshInstance3D

@export var radius := 5
@export var rings := 25
@export var radial_segments := 10
@export var barrel_width := 0.9


func _ready():
	var verts := PackedVector3Array()
	var uvs := PackedVector2Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()
	
	var cur_row := 0
	var last_row := 0
	var point := 0
	
	for i in range(rings + 1):
		var v := float(i) / rings
		var w := sin(PI * v)
		var y := cos(PI * v)
		
		for j in range(radial_segments + 1):
			var u := float(j) / radial_segments
			
			# Times 2.0 so it can paste it.
			var x := radius * sin(u * PI * 2.0)
			var z := radius * cos(u * PI * 2.0)
			
			var vertices := Vector3(
				x * radius * w * barrel_width,
				y * radius,
				z * radius * w * barrel_width
			)
			if i <= rings / 5 or i >= rings - rings / 5:
				vertices.z = sin(PI * radius)
				vertices.x = sin(PI * radius)
				vertices.y = 0
				normals.append(Vector3(0, 1 if i <= rings / 5 else -1, 0))
			else:
				normals.append(vertices.normalized())
			verts.append(vertices)
			
			uvs.append(Vector2(u, v))
			point += 1

			if i > 0 and j > 0:
				indices.append(last_row + j - 1)
				indices.append(last_row + j)
				indices.append(cur_row + j - 1)
				indices.append(last_row + j)
				indices.append(cur_row + j)
				indices.append(cur_row + j - 1)
		
		last_row = cur_row
		cur_row = point
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.BROWN
	
	var arr_mesh = ArrayMesh.new()
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = verts
	arrays[Mesh.ARRAY_TEX_UV] = uvs
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices
	
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	arr_mesh.surface_set_material(0, material)
	mesh = arr_mesh


func _process(delta):
	if Input.is_action_pressed("ui_left"):
		rotation.y += PI * delta
	if Input.is_action_pressed("ui_right"):
		rotation.y -= PI * delta
	if Input.is_action_pressed("ui_up"):
		rotation.x += sin(PI * delta)
	if Input.is_action_pressed("ui_down"):
		rotation.x -= sin(PI * delta)
