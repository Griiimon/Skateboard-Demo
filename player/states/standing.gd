class_name StandingState
extends PlayerStateMachineState

signal rolling

@export var turn_factor: float= 2.0



func on_enter():
	skater.linear_velocity= Vector3.ZERO


func on_exit():
	skater.figure_platform.look_at(skater.figure_platform.global_position + skater.models.basis.x)


func on_process(delta: float):
	skater.floor_align(delta)

	var platform: Node3D= skater.figure_platform
	platform.global_transform= platform.global_transform.interpolate_with(platform.global_transform.looking_at(platform.global_position - skater.models.basis.z), delta * 10)

	var turn: float= Input.get_axis("turn_right", "turn_left")
	
	skater.models.rotate(skater.models.basis.y, turn * turn_factor * delta)

	if Input.is_action_just_pressed("push"):
		rolling.emit()
		return
