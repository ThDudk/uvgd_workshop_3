class_name Biomes extends Resource

@export var biomes: Array[Biome] = []

static func build(_biomes: Array[Biome]) -> Biomes:
	var new = Biomes.new()
	new.biomes = _biomes
	return new

func biome_at(x: int, y: int) -> String:
	for biome in biomes:
		if biome.has_method("at"):
			if biome.at(x, y):
				return biome.id
	
	push_error("No biome found at (", x, ", ", y, ").")
	return ""
