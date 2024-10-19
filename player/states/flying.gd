class_name FlyingState
extends PlayerStateMachineState

signal land

@export var gravity_scale: float= 0.5



func on_enter():
	skater.gravity_scale= gravity_scale
	pass


func on_process(delta: float):
	skater.update_model_position(delta)


func on_physics_process(_delta: float):
	if skater.is_on_floor():
		print("Landed")
		land.emit()
