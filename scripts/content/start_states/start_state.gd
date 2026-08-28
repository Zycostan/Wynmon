class_name StartState
extends Resource

@export var player_start_state: TrainerStartState
@export var enemy_start_state: TrainerStartState

func generate_world_state() -> WorldState:
	return player_start_state.generate_world_state()

func generate_opponent_trainer() -> Trainer:
	return enemy_start_state.generate_trainer(false)
