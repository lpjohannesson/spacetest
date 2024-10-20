extends RigidBody3D
class_name Player

@export var bullet_scene: PackedScene

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	var move_dir := Vector3(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_down", "move_up"),
		Input.get_axis("move_forward", "move_backward"),)
	
	var quat = transform.basis.get_rotation_quaternion()
	
	apply_central_force(quat * move_dir * 5.0)
	
	apply_torque(quat * Vector3(
		Input.get_axis("aim_down", "aim_up"),
		Input.get_axis("aim_right", "aim_left"),
		Input.get_axis("turn_right", "turn_left")) * 0.5)
	
	if Input.is_action_just_pressed("shoot"):
		var bullet: Bullet = bullet_scene.instantiate()
		get_node("../..").add_child(bullet)
		
		bullet.global_position = global_position
		bullet.rotation = rotation
		bullet.velocity = linear_velocity + quat * Vector3.FORWARD * 100.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		apply_torque(
			transform.basis.get_rotation_quaternion() *
			Vector3(-event.relative.y, -event.relative.x, 0.0) * 0.5)
