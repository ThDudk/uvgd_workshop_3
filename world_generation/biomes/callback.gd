class_name CallbackBiomeCondition extends BiomeCondition

@export var callback: Callable

func is_satisfied(x: int, y: int) -> bool:
	return callback.call(x, y)
