class_name FlyingState
extends PlayerStateMachineState

signal land

@onready var align_delay: Timer = $"Align Delay"

@export var gravity_scale: float= 0.5



func on_enter():
	skater.gravity_scale= gravity_scale
	align_delay.start()


func on_process(delta: float):
	skater.update_model_position(delta, align_delay.is_stopped())


func on_physics_process(_delta: float):
	if skater.is_on_floor():
		print("Landed")
		land.emit()
