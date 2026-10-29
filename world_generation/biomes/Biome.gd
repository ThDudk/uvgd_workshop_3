class_name Biome extends Resource

@export var id: String
@export var condition: BiomeCondition

func at(x: int, y: int) -> bool:
	if condition != null and not condition.is_satisfied(x, y):
		return false
	
	return true

static func build(_id: String, _condition: BiomeCondition) -> Biome:
	var biome = Biome.new()
	biome.id = _id
	biome.condition = _condition
	return biome

static func default(_id: String) -> Biome:
	var biome = Biome.new()
	biome.id = _id
	biome.condition = null
	return biome

static func if_custom(_id: String, f: Callable) -> Biome:
	var biome = Biome.new()
	biome.id = _id
	biome.condition = BiomeCondition.custom(f)
	return biome

static func if_all(_id: String, conditions: Array[BiomeCondition]) -> Biome:
	var biome = Biome.new()
	biome.id = _id
	biome.condition = BiomeCondition.all(conditions)
	return biome

static func if_any(_id: String, conditions: Array[BiomeCondition]) -> Biome:
	var biome = Biome.new()
	biome.id = _id
	biome.condition = BiomeCondition.any(conditions)
	return biome
