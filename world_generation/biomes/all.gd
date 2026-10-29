class_name AllBiomeCondition extends BiomeCondition

@export var conditions: Array[BiomeCondition]

func is_satisfied(x: int, y: int) -> bool:
	return conditions.all(func(condition):
		return condition.is_satisfied(x, y)
	);
