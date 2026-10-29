extends Node2D

@export_category("Seed")
@export var randomize_seed: bool = false
@export var world_seed: int = 0

@export_category("Requirements")
@export var world_size := Vector2i(128, 128)
@export var ground_tilemap: TileMapLayer
@export var object_storage: Node
@export var world_generator: Node

var generating := false

func build_context() -> GenerationContext:
	var ctx = GenerationContext.new()
	ctx.scene_tree = get_tree()
	ctx.random = RandomNumberGenerator.new()
	ctx.ground_tilemap = self.ground_tilemap
	ctx.object_storage = self.object_storage
	ctx.world_size = self.world_size
	
	return ctx

func _ready() -> void:
	await generate_world()

func generate_world():
	assert(world_generator != null, "Failed to generate world. No world generator.")
	assert(ground_tilemap != null, "Failed to generate world. No ground tilemap.")
	assert(object_storage != null, "Failed to generate world. No object storage.")
	assert(world_size != null, "Failed to generate world. No world size.")
	
	generating = true
	
	clear_world()
	
	await get_tree().create_timer(0.1).timeout
	
	var ctx = build_context()
	ctx.set_seed(world_seed)
	
	await world_generator.generate(ctx)
	
	generating = false

func clear_world():
	ground_tilemap.clear()
	
	for child in object_storage.get_children():
		child.queue_free()

func _process(_delta: float) -> void:
	if not generating and Input.is_action_just_pressed("regenerate"):
		await generate_world()
