extends CharacterBody3D

@onready var camera: PhantomCamera3D = %ThirdPersonCamera

@export var speed = 5.0
@export var accel = 5.0
@export var deccel = 5.0
@export var jump_velocity = 0

@export var mouse_sens = 0.1

var _rotation_direction: float = 0.0

const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _ready() -> void:
	camera.set_third_person_rotation(Vector3(rotation.x, rotation.y + PI/2, rotation.z))


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := (1 * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, camera.get_third_person_rotation().y)
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
	if Vector2(velocity.z, velocity.x).length() > 0:
		_rotation_direction = Vector2(velocity.z, velocity.x).angle()
	rotation.y = lerp_angle(rotation.y, _rotation_direction, delta * 10)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Apply the motion to the camera's rotation
		var mouse_rotation := Vector3.ZERO
		mouse_rotation.y = -event.screen_relative.x
		mouse_rotation.x = -event.screen_relative.y
		var camera_rotation_degrees = camera.get_third_person_rotation_degrees()
		camera_rotation_degrees += mouse_rotation * mouse_sens
		camera_rotation_degrees.x = clamp(camera_rotation_degrees.x, -80, -10)
		camera.set_third_person_rotation_degrees(camera_rotation_degrees)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if Input.is_action_just_pressed("free_mouse"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
