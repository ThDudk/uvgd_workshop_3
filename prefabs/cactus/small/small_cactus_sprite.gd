@tool
extends Sprite2D

const ATLAS = preload("uid://dpqs6avvfnwcm")
const SPRITE_SIZE: Vector2i = Vector2i(16, 16)


func update(api: SmallCactusAPI):
	texture = atlas_texture(api)

static func atlas_texture(api: SmallCactusAPI) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ATLAS;
	atlas.region = atlas_region(api)
	
	return atlas

static func atlas_region(api: SmallCactusAPI) -> Rect2i:
	var y_offset = 0
	match api.type:
		SmallCactusAPI.Type.Green: y_offset = 0
		SmallCactusAPI.Type.Brown: y_offset = 48
	
	var x_offset = 0
	match api.state:
		SmallCactusAPI.State.Plain: x_offset = 0
		SmallCactusAPI.State.Flowering: x_offset = 16
	
	return Rect2i(x_offset, y_offset, SPRITE_SIZE.x, SPRITE_SIZE.y)
