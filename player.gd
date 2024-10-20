extends RigidBody3D
class_name Player

@export var bullet_cast: RayCast3D

func shoot_bullet(quat: Quaternion) -> void:
	var collider := bullet_cast.get_collider()
	
	if not collider is RigidBody3D:
		return
	
	collider.apply_impulse(
		quat * Vector3.FORWARD,
		collider.to_local(bullet_cast.get_collision_point()))

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
	
	if Input.is_action_pressed("brake"):
		linear_velocity *= pow(0.08, delta)
		angular_velocity *= pow(0.08, delta)
	
	if Input.is_action_just_pressed("shoot"):
		shoot_bullet(quat)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		apply_torque(
			transform.basis.get_rotation_quaternion() *
			Vector3(-event.relative.y, -event.relative.x, 0.0) * 0.5)
