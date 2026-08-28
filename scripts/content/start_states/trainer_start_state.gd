class_name TrainerStartState
extends Resource

@export var name: String
@export var monsters: Array[MonsterStartState]
@export var items: Array[ItemStartState]
@export var is_wild_encounter: bool = false

func generate_trainer(is_player: bool) -> Trainer:
	var generated_monsters: Array[Monster] = []
	for monster in monsters:
		generated_monsters.append(monster.generate())
	
	var trainer = TrainerController.create_trainer(generated_monsters, is_player)
	trainer.name = name
	trainer.is_wild_encounter = is_wild_encounter
	
	for item in items:
		TrainerController.add_item(trainer, item.resoure, item.quantity)
	
	return trainer
	
