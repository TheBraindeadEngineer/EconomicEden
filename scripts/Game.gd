extends Node2D

signal ui_update(data)
signal assets_update(assets)

@onready var tile_map: TileMap = $TileMap
@onready var tree_farms: Node = $Facilites/TreeFarms

const LAND = Vector2i(0, 0)
const TREE_FARM = Vector2i(2, 0)

var selected_tile

var data = {
	"money": 1000,
	"owned_land": 10,
	"placed_land": 0,
	"land_price": floor(600 * pow(1.0961757, 10.0))
}

func _land_bought():
	data.land_price = floor(600 * pow(1.0961757, data.owned_land))

var assets = {
	"wood": 0
}

func _ready():
	ui_update.emit(data)
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if Input.is_action_just_pressed("click") && selected_tile != null:
			var mouse_pos = get_global_mouse_position()
			var tile_pos = tile_map.local_to_map(mouse_pos)
			var tile = tile_map.get_cell_tile_data(0, tile_pos)
			if selected_tile == LAND && tile == null:
				if data["owned_land"] > 0:
					data["owned_land"] -= 1
				elif data["money"] >= data["land_price"]:
					data["money"] -= data["land_price"]
					_land_bought()
				else:
					tile = null
					return
				ui_update.emit(data)
				place_tile(tile_pos, LAND, "LAND")
				tile = null
				return
			if tile == null:
				return
			elif selected_tile == TREE_FARM && tile.get_custom_data("TYPE") == "LAND":
				if data["money"] >= 100:
					data["money"] -= 100
					place_tree_farm(tile_pos)
					ui_update.emit(data)
			tile = null

func place_tile(position, tile, type):
	tile_map.set_cell(0, position)
	tile_map.set_cell(0, position, 0, tile, 0)
	tile_map.get_cell_tile_data(0, position).set_custom_data("TYPE", type)

func place_tree_farm(tile_pos):
	var tree_farm = Timer.new()
	tree_farm.set_autostart(true)
	tree_farm.set_wait_time(5)
	tree_farm.connect("timeout", _on_tree_farm_done)
	tree_farms.add_child(tree_farm)
	tree_farm.start()
	place_tile(tile_pos, TREE_FARM, "TREE FARM")

func _on_tree_farm_done():
	assets["wood"] += 2
	assets_update.emit(assets)

func _on_selected_tile_changed(new_selected_tile):
	selected_tile = new_selected_tile
