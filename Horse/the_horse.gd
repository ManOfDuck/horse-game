extends CharacterBody3D


@export var walk_speed: float = 1.0
@export var trot_speed: float = 2.0
@export var gallop_speed: float = 5.0
@export var accel: float = 5.0
@export var deccel: float = 2.0
@export var jump_velocity: float = 1.0

const WALK_ANIM_SPEED: float = 1.0
const TROT_ANIM_SPEED: float = 2.0
const GALLOP_ANIM_SPEED: float = 5.0

var target: Node3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func follow_me(trainer: Node3D) -> void:
	target = trainer


func stay_here(trainer: Node3D) -> void:
	if target == trainer:
		target = null
