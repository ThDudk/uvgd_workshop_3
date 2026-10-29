class_name RemapRangeWithCurveFilter extends NoiseFilter

var range_min: float
var range_max: float
var curve: Curve

func filter(value: float) -> float:
	if value >= range_min and value <= range_max:
		var percent_of_range = (value - range_min) / (range_max - range_min)
		return lerpf(range_min, range_max, curve.sample(percent_of_range))
	else:
		return value
