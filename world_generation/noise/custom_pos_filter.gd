class_name CustomPositionalNoiseFilter extends NoiseFilter

var f: Callable

func filter_pos(value: float, x: int, y: int) -> float:
	return f.call(value, x, y)
