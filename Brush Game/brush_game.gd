extends Node3D

@onready var camera: TouchCamera = $TouchCamera
@onready var brush: Node3D = $Brush





func _physics_process(delta: float) -> void:
	if not camera.is_touch_active:
		brush.position = Vector3(0, -1000, 0)
		return
	
	brush.look_at_from_position(
			camera.touch_position, 
			camera.touch_position + camera.touch_normal,
			Vector3.UP
		)
