class_name WorldState

const SAVE_PATH = "user://save.dat"
const MAX_PARTY_SIZE = 4

var party: Array[Monster] = []
var bag: Array[Item] = []

var current_map: String = ""
var player_position: Vector2 = Vector2.ZERO

var badges: Array[Badge.Type] = []
var defeated_trainers: Array[TrainerFlag.Type] = []
var story_flags: Array[StoryFlag.Type] = []

func party_full() -> bool:
	return party.size() >= MAX_PARTY_SIZE

func add_monster_to_party(monster: Monster) -> bool:
	if party_full():
		return false
	party.append(monster)
	return true

func get_first_alive_monster() -> Monster:
	for monster in party:
		if monster.hp > 0:
			return monster
	return null

func any_monster_alive() -> bool:
	return get_first_alive_monster() != null
