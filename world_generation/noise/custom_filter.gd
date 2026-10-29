class_name CustomNoiseFilter extends NoiseFilter

var f: Callable

func filter(value: float) -> float:
	return f.call(value)
