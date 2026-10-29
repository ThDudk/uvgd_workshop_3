@tool
extends Sprite2D

const ATLAS = preload("uid://dvm3i2ncltvg7")
const SPRITE_SIZE: Vector2i = Vector2i(32, 48)

func update(api: PineTreeAPI) -> void:
	texture = atlas_texture(api)

func atlas_texture(api: PineTreeAPI) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ATLAS
	atlas.region = texture_region(api)
	
	return atlas

func texture_region(api: PineTreeAPI) -> Rect2i:
	var y_offset = 0
	match api.leaf_color:
		PineTreeAPI.LeafColor.Green: y_offset = 0
		PineTreeAPI.LeafColor.Pink: y_offset = SPRITE_SIZE.y
		PineTreeAPI.LeafColor.Red: y_offset = SPRITE_SIZE.y * 2
		PineTreeAPI.LeafColor.Orange: y_offset = SPRITE_SIZE.y * 3
	
	var x_offset = 0
	if api.state == PineTreeAPI.State.CutDown:
		x_offset = SPRITE_SIZE.x * 6
		match api.trunk_color:
			PineTreeAPI.TrunkColor.Brown: x_offset += 0
			PineTreeAPI.TrunkColor.Gray: x_offset += SPRITE_SIZE.x
	else:
		match api.trunk_color:
			PineTreeAPI.TrunkColor.Brown: x_offset += 0
			PineTreeAPI.TrunkColor.Gray: x_offset += SPRITE_SIZE.x * 2
	
		match api.state:
			PineTreeAPI.State.Normal: x_offset += 0
			PineTreeAPI.State.Snowy: x_offset += SPRITE_SIZE.x
	
	
	
	return Rect2i(x_offset, y_offset, SPRITE_SIZE.x, SPRITE_SIZE.y)
