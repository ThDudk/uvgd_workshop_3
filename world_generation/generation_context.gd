class_name GenerationContext extends Object

var scene_tree: SceneTree
var world_size: Vector2i
var ground_tilemap: TileMapLayer
var object_storage: Node
var random: RandomNumberGenerator
var world_seed: int

func set_seed(_seed: int):
	world_seed = _seed
	random.seed = _seed

# Tilemap API

enum Terrain {Water, Sand, Grass, Fall, Snow, Ice}

## Internal: returns the BetterTerrain index of a terrain type.
func _terrain_index(terrain: Terrain) -> int:
	match terrain:
		Terrain.Water: return 0
		Terrain.Sand: return 1
		Terrain.Grass: return 2
		Terrain.Fall: return 3
		Terrain.Snow: return 4
		Terrain.Ice: return 5
		_: 
			push_error("Failed to find terrain index for ", terrain)
			return -1 

## Sets the terrain value of a tile.
func set_tile(tile: Vector2i, terrain: Terrain):
	BetterTerrain.set_cell(self.ground_tilemap, tile, _terrain_index(terrain))

## Updates tilemap tiles based on the terrain. Note: this blocks the main thread, and may be unperformant.
func update_terrain():
	BetterTerrain.update_terrain_cells(self.ground_tilemap, tiles(), false)

## Calculates which tiles to replace each tilemap tile with based on terrain in a background worker thread. 
## You must wait until the ChangeSet is finished (ex. await change_set.await_finished() ) before applying the changeset.
func calculate_terrain_tiles_in_background() -> ChangeSet:
	## maps all tile positions to the terrain at that tile.
	var tile_to_terrain: Dictionary[Vector2i, int] = {}
	for tile in tiles():
		tile_to_terrain[tile] = BetterTerrain.get_cell(self.ground_tilemap, tile)
	
	var change_set = BetterTerrain.create_terrain_changeset(self.ground_tilemap, tile_to_terrain)
	return ChangeSet.new(change_set)

## Returns: the size of tilemap tiles.
func tile_size() -> Vector2i:
	return ground_tilemap.tile_set.tile_size

# Prefab API

const BUSH = preload("uid://bbxakiihurhdm")
const LARGE_CACTUS = preload("uid://bn54g3apptecg")
const SMALL_CACTUS = preload("uid://34di4gous2c0")
const MUSHROOM = preload("uid://exxlvq2eegif")
const PINE_TREE = preload("uid://b7vw5235tl5bp")
const TREE = preload("uid://jku6xoudtedd")

func spawn_bush(pos: Vector2) -> BushAPI:
	var prefab: BushAPI = BUSH.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

func spawn_large_cactus(pos: Vector2) -> LargeCactusAPI:
	var prefab: LargeCactusAPI = LARGE_CACTUS.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

func spawn_small_cactus(pos: Vector2) -> SmallCactusAPI:
	var prefab: SmallCactusAPI = SMALL_CACTUS.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

func spawn_mushroom(pos: Vector2) -> MushroomAPI:
	var prefab: MushroomAPI = MUSHROOM.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

func spawn_pine_tree(pos: Vector2) -> PineTreeAPI:
	var prefab: PineTreeAPI = PINE_TREE.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

func spawn_tree(pos: Vector2) -> TreeAPI:
	var prefab: TreeAPI = TREE.instantiate()
	prefab.position = pos
	object_storage.add_child(prefab)
	return prefab

# Random API

## Calls self.random.randf()
func randf() -> float:
	return random.randf()

## Calls self.random.randf_range(from, to)
func randf_range(from: float, to: float) -> float:
	return random.randf_range(from, to)

## Calls self.random.randi()
func randi() -> int:
	return random.randi()

## Calls self.random.randi_range(from, to)
func randi_range(from: int, to: int) -> int:
	return random.randi_range(from, to)

## Takes a list of options, where keys are the enum variant, and values are the relative likelihood.
func pick_random_enum_value(options: Dictionary[int, int]) -> int:
	var total = options.values().reduce(func(acc, b): return acc + b)
	
	var rand = randi_range(0, total)
	
	var running_total = 0
	for key in options.keys():
		running_total += options[key]
		if running_total >= rand:
			return key
	
	push_error("Failed to pick random. This should be impossible.")
	return 0

# World Size API

func for_all_tiles(f: Callable):
	for x in range(0, world_size.x):
		for y in range(0, world_size.y):
			f.call(Vector2i(x, y))

func tiles() -> Array[Vector2i]:
	var array: Array[Vector2i] = []
	
	for_all_tiles(func(tile):
		array.append(tile)
	);
	
	return array

func tile_world_size() -> Vector2i:
	return world_size

func real_world_size() -> Vector2:
	return world_size * tile_size()
