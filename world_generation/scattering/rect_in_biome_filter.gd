class_name RectInBiomeFilter extends ScatterFilter

var global_to_local: Transform2D
var cell_size: Vector2i
var biomes: Biomes
var biome: String
var size: Vector2

func filter(array: Array) -> Array:
	return array.filter(func(point):
		var min_pos = (point - size / 2.0)
		var max_pos = (point + size / 2.0)
		
		for x in range(int(min_pos.x), int(max_pos.x), cell_size.x):
			for y in range(int(min_pos.y), int(max_pos.y), cell_size.y):
				var local_pos = global_to_local * point
				var tile = Vector2i(
					floori(local_pos.x / cell_size.x), 
					floori(local_pos.y / cell_size.y)
				);
				
				if biomes.biome_at(tile.x, tile.y) != biome:
					return false
		
		return true
	)
