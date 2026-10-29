class_name RemoveRandomFilter extends ScatterFilter

var random: RandomNumberGenerator
var removal_percentage: float

func filter(array: Array) -> Array:
	return array.filter(func(_point):
		return random.randf() > removal_percentage
	);
