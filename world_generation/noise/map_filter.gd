class_name MapFilter extends NoiseFilter

@export
var old_min: float = -1
@export
var old_max: float = 1
@export
var new_min: float = 0
@export
var new_max: float = 1

func filter(value: float) -> float:
	return (value - old_min) / (old_max - old_min) * (new_max - new_min) + new_min
