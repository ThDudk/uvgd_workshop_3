class_name RemapRangeFilter extends NoiseFilter

var range_min: float
var range_max: float
var new_min: float
var new_max: float

func filter(value: float) -> float:
	if value >= range_min and value <= range_max:
		# Same formula as MapFilter
		return (value - range_min) / (range_max - range_min) * (new_max - new_min) + new_min
	else:
		return value
