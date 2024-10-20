extends Node3D

@export var test_cube_scene: PackedScene

func _ready() -> void:
	for x in range(5):
		for y in range(5):
			for z in range(5):
				var cube: TestCube = test_cube_scene.instantiate()
				add_child(cube)
				
				cube.position = Vector3(x, y, z) * 10
				var material := \
					cube.mesh.get_surface_override_material(0).duplicate()
				cube.mesh.set_surface_override_material(0, material)
				
				material.albedo_color = Color(randf(), randf(), randf())

func _physics_process(delta: float) -> void:
	for body: RigidBody3D in get_children():
		var to_body = global_position - body.global_position
		var distance = to_body.length()
		
		if distance == 0.0:
			continue
		
		body.apply_central_force(
			to_body / (distance * distance) * 0.1)
