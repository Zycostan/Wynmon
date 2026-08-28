class_name TrainerStartState
extends Resource

@export var name: String
@export var monsters: Array[MonsterStartState]
@export var items: Array[ItemStartState]

func generate_world_state() -> WorldState:
	var world_state = WorldState.new()
	world_state.player_name = name
	
	for monster in monsters:
		world_state.monsters.append(monster.generate())
	
	for item in items:
		var new_item = Item.new()
		new_item.resource = item.resoure
		new_item.quantity = item.quantity
		world_state.items.append(new_item)
	
	return world_state

func generate_trainer(is_player: bool) -> Trainer:
	var generated_monsters: Array[Monster] = []
	for monster in monsters:
		generated_monsters.append(monster.generate())
	
	var trainer = TrainerController.create_trainer(generated_monsters, is_player)
	trainer.name = name
	
	for item in items:
		TrainerController.add_item(trainer, item.resoure, item.quantity)
	
	return trainer
	
