class_name RollingState
extends PlayerStateMachineState

signal stand
signal jump

@export var push_force: float= 1.0
@export var steering_factor: float= 1.0
@export var brake_factor: float= 0.1

@export var gravity_scale: float= 0.1



func on_enter():
	skater.gravity_scale= gravity_scale

	if get_state_machine().previous_state == get_state_machine().standing_state:
		skater.apply_central_impulse(-skater.models.basis.z * push_force)


func on_process(delta: float):
	skater.update_model_position(delta, true, 1.0)
	
	if skater.linear_velocity and not is_equal_approx(abs(skater.linear_velocity.normalized().dot(skater.models.basis.y)), 1.0):
		skater.models.transform= skater.models.transform.interpolate_with(skater.models.transform.looking_at(skater.models.position + skater.linear_velocity.normalized(), skater.models.basis.y), delta * 10)


func on_physics_process(delta):
	if Input.is_action_just_pressed("push"):
		skater.apply_central_impulse(-skater.models.basis.z * push_force)
	elif skater.linear_velocity.length() < 0.1:
		stand.emit()
		return

	if not skater.is_on_floor():
		jump.emit()
		return
		


func on_integrate_forces(state: PhysicsDirectBodyState3D):
	var steer= Input.get_axis("turn_right", "turn_left")

	if steer and skater.is_on_floor():
		state.linear_velocity= state.linear_velocity.rotated(skater.models.basis.y, steer * steering_factor * state.step)
	
	if Input.is_action_pressed("brake"):
		state.linear_velocity= state.linear_velocity * (1 - brake_factor * state.step)
