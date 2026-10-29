class_name InBiomeFilter extends ScatterFilter

var global_to_local: Transform2D
var cell_size: Vector2i
var biomes: Biomes
var biome: String

func filter(points: Array) -> Array:
	return points.filter(func(point):
		var local_pos = global_to_local * point
		var tile = Vector2i(
			floori(local_pos.x / cell_size.x), 
			floori(local_pos.y / cell_size.y)
		);
		
		return biomes.biome_at(tile.x, tile.y) == biome
	)
