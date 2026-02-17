extends Node3D

@onready var camera: TouchCamera = $TouchCamera
@onready var brush: MeshInstance3D = $Brush



func _physics_process(delta: float) -> void:
	#if not camera.is_touch_valid:
		#return
	
	brush.look_at_from_position(
			camera.touch_position, 
			camera.touch_position + camera.touch_normal,
			Vector3.UP
		)
