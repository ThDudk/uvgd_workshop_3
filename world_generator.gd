class_name WorldGenerator extends Node

func generate(ctx: GenerationContext):
	generate_floor(ctx)
	
	print("World Generated!")

func generate_floor(ctx: GenerationContext):
	ctx.for_all_tiles(func(tile_pos):
		ctx.set_tile(tile_pos, GenerationContext.Terrain.Grass)
	);
	
	ctx.update_terrain()
