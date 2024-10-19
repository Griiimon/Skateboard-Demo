class_name PlayerStateMachine
extends FiniteStateMachine

@onready var standing_state: StandingState= $Standing
@onready var rolling_state: RollingState = $Rolling
@onready var flying_state: FlyingState = $Flying



func _ready():
	super()
	
	standing_state.rolling.connect(change_state.bind(rolling_state))
	rolling_state.stand.connect(change_state.bind(standing_state))
	rolling_state.jump.connect(change_state.bind(flying_state))
	flying_state.land.connect(change_state.bind(rolling_state))
