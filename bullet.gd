extends CharacterBody3D
class_name Bullet

func _physics_process(delta: float) -> void:
	move_and_slide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		return
	
	if body is RigidBody3D:
		body.apply_impulse(velocity * 0.02, body.to_local(global_position))
	
	queue_free()
