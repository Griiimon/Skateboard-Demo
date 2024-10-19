class_name Skater
extends RigidBody3D

@onready var models: Node3D = $Models
@onready var floor_raycast: RayCast3D = %"Floor RayCast"
@onready var floor_shapecast: ShapeCast3D = %"Floor ShapeCast"
@onready var figure_platform: Node3D = %"Figure Platform"
@onready var state_machine: FiniteStateMachine = $"State Machine"


var body_state: PhysicsDirectBodyState3D



func _ready():
	models.top_level= true


func _integrate_forces(state):
	body_state= state

	state_machine.on_integrate_forces(state)


func update_model_position(delta: float, floor_align_factor: float= 10.0):
	models.position= global_position
	
	floor_align(delta * floor_align_factor)


func floor_align(weight: float):
	var target_normal= Vector3.UP
	#if floor_raycast.is_colliding():
		#target_normal= floor_raycast.get_collision_normal()
	
	if floor_shapecast.is_colliding():
		target_normal= Vector3.ZERO
		for idx in floor_shapecast.get_collision_count():
			target_normal+= floor_shapecast.get_collision_normal(idx)
	target_normal= target_normal.normalized()
	
	models.transform= models.transform.interpolate_with(align_with_y(target_normal), weight)


func is_on_floor():
	if not body_state: return false
	
	return body_state.get_contact_count() > 0


func align_with_y(new_y: Vector3)-> Transform3D:
	var xform: Transform3D= Transform3D(models.transform)
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform
