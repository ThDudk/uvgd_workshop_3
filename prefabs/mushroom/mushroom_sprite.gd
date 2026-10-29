@tool
class_name MushroomSprite extends Sprite2D

const ATLAS = preload("uid://gbb643jh4b8e")
const SPRITE_SIZE: Vector2i = Vector2i(16, 16)

func update(api: MushroomAPI) -> void:
	texture = atlas_texture(api)

func atlas_texture(api: MushroomAPI) -> AtlasTexture:
	var atlas = AtlasTexture.new()
	atlas.atlas = ATLAS
	atlas.region = texture_region(api)
	
	return atlas

func texture_region(api: MushroomAPI) -> Rect2i:
	var y_offset = 0
	match api.type:
		MushroomAPI.Type.Red: y_offset = 0
		MushroomAPI.Type.Turquoise: y_offset = 16
		MushroomAPI.Type.Green: y_offset = 32
		MushroomAPI.Type.Pink: y_offset = 48
		MushroomAPI.Type.Brown: y_offset = 64
	
	var x_offset = 0
	match api.size:
		MushroomAPI.Size.Large: x_offset = 0
		MushroomAPI.Size.Medium: x_offset = 16
		MushroomAPI.Size.Small: x_offset = 32
	
	return Rect2i(x_offset, y_offset, SPRITE_SIZE.x, SPRITE_SIZE.y)
