class_name WorldSize extends Resource

@export
var size: Vector2i
@export
var tile_size: Vector2i = Vector2i(16, 16)

## Calls `f` for all tiles in the world. The input is the tile position as a `Vector2i`
func for_all_tiles(f: Callable):
	for x in range(0, size.x):
		for y in range(0, size.y):
			f.call(Vector2i(x, y))

func all_tiles() -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	for_all_tiles(func(tile):
		array.append(tile)
	);
	
	return array

func size_in_tiles() -> Vector2i:
	return size

func width_in_tiles() -> int:
	return size.x

func height_in_tiles() -> int:
	return size.y


func size_in_world() -> Vector2:
	return size * tile_size

func width_in_world() -> float:
	return size.x * tile_size.x

func height_in_world() -> float:
	return size.y * tile_size.y
