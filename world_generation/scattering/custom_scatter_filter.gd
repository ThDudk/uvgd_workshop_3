class_name CustomScatterFilter extends ScatterFilter

var callable: Callable

func filter(array: Array) -> Array:
	return array.filter(callable)
