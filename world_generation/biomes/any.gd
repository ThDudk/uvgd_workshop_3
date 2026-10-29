class_name AnyBiomeCondition extends BiomeCondition

@export var conditions: Array[BiomeCondition]

func is_satisfied(x: int, y: int) -> bool:
	return conditions.any(func(condition):
		return condition.is_satisfied(x, y)
	);
