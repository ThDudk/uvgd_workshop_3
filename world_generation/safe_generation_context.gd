class_name SafeGenerationContext extends Object

var mutex: Mutex
var _tile_size: Vector2i
var _world_size: Vector2i
var _random: RandomNumberGenerator
var _world_seed: int

func _init(__tile_size: Vector2i, __world_size: Vector2i, __random: RandomNumberGenerator, __world_seed: int) -> void:
	mutex = Mutex.new()
	self._tile_size = __tile_size
	self._world_size = __world_size
	self._world_seed = __world_seed
	self._random = __random


## Returns: the size of tilemap tiles.
func tile_size() -> Vector2i:
	return _tile_size

func for_all_tiles(f: Callable):
	for x in range(0, _world_size.x):
		for y in range(0, _world_size.y):
			f.call(Vector2i(x, y))

func tiles() -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	for_all_tiles(func(tile):
		array.append(tile)
	);
	
	return array

func tile_world_size() -> Vector2i:
	return _world_size

func real_world_size() -> Vector2:
	return _world_size * tile_size()

func to_world_pos(tile: Vector2i) -> Vector2:
	return tile * tile_size()

func to_tile_pos(world_pos: Vector2) -> Vector2i:
	@warning_ignore("narrowing_conversion")
	return Vector2i(
		world_pos.x / tile_size().x,
		world_pos.y / tile_size().y
	);

# Rand functions

func lock_random() -> RandomNumberGenerator:
	mutex.lock()
	
	return self._random

func unlock_random():
	mutex.unlock()

# Filter Helpers

func rect_in_map(world_pos: Vector2, size: Vector2i):
	var top_left = (world_pos - size / 2.0)
	var bottom_right = (world_pos + size / 2.0)
	
	if bottom_right.x > real_world_size().x or bottom_right.y > real_world_size().y:
		return false
	
	if top_left.x < 0 or top_left.y < 0:
		return false
	
	return true

func rect_in_biome(world_pos: Vector2, size: Vector2i, biome_getter: Callable, biome: String) -> bool:
	return rect_in_one_of_biomes(world_pos, size, biome_getter, [biome])

func rect_in_one_of_biomes(world_pos: Vector2, size: Vector2i, biome_at_callback: Callable, biomes: Array[String]) -> bool:
	var top_left = (world_pos - size / 2.0)
	var bottom_right = (world_pos + size / 2.0)
	
	for x in range(int(top_left.x), int(bottom_right.x), tile_size().x):
		for y in range(int(top_left.y), int(bottom_right.y), tile_size().y):
			var tile = to_tile_pos(world_pos)
			
			if biome_at_callback.call(tile.x, tile.y) not in biomes:
				return false
	
	return true
