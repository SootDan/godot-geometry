extends Node3D

@export var radius := 5.0
@export var rings := 25
@export var radial_segments := 10


func _ready() -> void:
	var vertices = PackedVector3Array()
	vertices.push_back(Vector3(0, 1, 0))
	vertices.push_back(Vector3(1, 0, 0))
	vertices.push_back(Vector3(0, 0, 1))
	

	var arr_mesh = ArrayMesh.new()
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	
	var material := StandardMaterial3D.new()
	material.albedo_color = Color.CRIMSON

	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	arr_mesh.surface_set_material(0, material)
	#$MeshInstance3D.mesh = arr_mesh
