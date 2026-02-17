class_name TouchCamera extends Camera3D

@export var max_speed: float = 5000.0

@onready var touch_cast: RayCast3D = $TouchCast

var current_touch: Vector2 = Vector2(-INF, -INF)
var target_touch: Vector2 = Vector2(-INF, -INF)

var is_touch_active: bool = false

var is_touch_valid: bool:
	get:
		return touch_cast.is_colliding() if touch_cast else false

var touch_position: Vector3 = Vector3(0, 0, 0):
	get:
		if touch_cast and touch_cast.is_colliding():
			return touch_cast.get_collision_point()
		else:
			return touch_position

var touch_normal: Vector3 = Vector3(0, 0, 0):
	get:
		if touch_cast and touch_cast.is_colliding():
			return touch_cast.get_collision_normal()
		else:
			return touch_normal

var touched_object: Object:
	get:
		return touch_cast.get_collider() if touch_cast else null

func _physics_process(delta: float) -> void:
	if target_touch == Vector2(-INF, -INF):
		return
	
	if max_speed == -1 or current_touch == Vector2(-INF, -INF):
		current_touch = target_touch
	else:
		current_touch = current_touch.move_toward(target_touch, max_speed * delta)
	
	touch_cast.global_position = project_ray_origin(current_touch)
	touch_cast.target_position = project_local_ray_normal(current_touch) * 20


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		_handle_touch(event.position)
	elif event is InputEventScreenTouch:
		_handle_touch(event.position)
		if event.is_released():
			is_touch_active = false


func _handle_touch(screen_pos: Vector2) -> void:
	target_touch = screen_pos
	is_touch_active = true
	#$TouchExpireTimer.start()


func _on_touch_expire_timer_timeout() -> void:
	is_touch_active = false
