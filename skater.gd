class_name Skater
extends RigidBody3D

@export var push_force: float= 1.0
@export var steering_factor: float= 1.0

@onready var model = $"Skater Model"
@onready var raycast = $"Skater Model/RayCast3D"

var body_state: PhysicsDirectBodyState3D



func _ready():
	model.top_level= true


func _process(delta):
	model.position= global_position
	
	var target_normal= Vector3.UP
	if raycast.is_colliding():
		#for idx in body_state.get_contact_count():
			#target_normal+= body_state.get_contact_local_normal(idx)
		target_normal= raycast.get_collision_normal()
	target_normal= target_normal.normalized()
	
	model.transform= model.transform.interpolate_with(align_with_y(model.transform, target_normal), delta * 10)
	#model.transform= align_with_y(model.transform, target_normal)
	if linear_velocity and not is_equal_approx(abs(linear_velocity.normalized().dot(model.basis.y)), 1.0):
		model.transform= model.transform.interpolate_with(model.transform.looking_at(model.position + linear_velocity.normalized(), model.basis.y), delta * 10)


func _physics_process(delta):
	if Input.is_action_just_pressed("push"):
		apply_central_impulse(-model.basis.z * push_force)


func _integrate_forces(state):
	body_state= state

	var steer= Input.get_axis("turn_right", "turn_left")

	if steer and is_on_floor():
		#if not state.linear_velocity:
			#state.linear_velocity= -model.basis.z * 0.01

		state.linear_velocity= state.linear_velocity.rotated(model.basis.y, steer * steering_factor * state.step)


func is_on_floor():
	return body_state.get_contact_count() > 0


func align_with_y(xform: Transform3D, new_y: Vector3)-> Transform3D:
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
