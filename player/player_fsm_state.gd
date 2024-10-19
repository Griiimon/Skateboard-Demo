class_name PlayerStateMachineState
extends StateMachineState


var skater: Skater


func _ready() -> void:
	skater= get_parent().get_parent()
	assert(skater != null)
