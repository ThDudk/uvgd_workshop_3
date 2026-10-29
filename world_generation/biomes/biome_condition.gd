## Marker class for biome conditions. 
## This informally guarentees that `is_satisfied(x, y)` exists. 
## It is the subclass's job to guarentee this however.
class_name BiomeCondition extends Resource

static func all(conditions: Array[BiomeCondition]) -> AllBiomeCondition:
	var condition = AllBiomeCondition.new()
	condition.conditions = conditions
	return condition

static func any(conditions: Array[BiomeCondition]) -> AnyBiomeCondition:
	var condition = AnyBiomeCondition.new()
	condition.conditions = conditions
	return condition

static func custom(f: Callable) -> CallbackBiomeCondition:
	var condition = CallbackBiomeCondition.new()
	condition.callback = f
	return condition

static func noise_less_than(noise: FilteredNoise, value: float) -> CallbackBiomeCondition:
	var condition = CallbackBiomeCondition.new()
	condition.callback = func(x, y):
		return noise.value_at(x, y) < value
		
	return condition
