extends Node2D

@onready var tile_map: TileMap = $TileMap

var selected_tile = Vector2i(0,0)

func _ready():
	pass

func _input(event):
	if Input.is_key_pressed(KEY_1):
		selected_tile = Vector2i(0,0)
	if Input.is_key_pressed(KEY_2):
		selected_tile = Vector2i(1,0)
		
	if Input.is_action_just_pressed("click"):
		var mouse_pos = get_global_mouse_position()
		var tile_pos = tile_map.local_to_map(mouse_pos)
		
		tile_map.set_cell(0, tile_pos, 0, selected_tile, 0)
