extends CanvasLayer

class_name HUD

signal selected_tile_changed(new_selected_tile)

signal build_selected(building)
signal asset_selected(asset)
signal assets_update(assets)
signal asset_menu_selected(asset, data)

@onready var asset_selection_menu = %AssetMenu

@onready var money_label = %MoneyLabel
@onready var owned_land_label = %OwnedLandLabel

@onready var building_menu = %BuildingMenu

@onready var selected_menu = %SelectedMenu
@onready var selected_label = %SelectedLabel
@onready var price_label = %PriceLabel

@onready var asset_menu = %AssetsContainer

@onready var wood_label = %WoodLabel

var build_menu_layer = 1

const LAND = Vector2i(0, 0)
const TREE_FARM = Vector2i(2, 0)

var _building = false
var _assets_menu = false

var _data = {}

var _assets = {
	"wood": 0
}

func _ready():
	money_label.text = "Money: 1000$"
	owned_land_label.text = "Owned Land: 10"
	selected_tile_changed.connect(_on_selected_tile_changed)

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("build_menu"):
			toggle_build_menu()
			return
		if _building && build_menu_layer == 1:
			if Input.is_key_pressed(KEY_1):
				selected_tile_changed.emit(LAND)
			elif Input.is_key_pressed(KEY_2):
				selected_tile_changed.emit(TREE_FARM)
			return
		if Input.is_action_just_pressed("asset_menu"):
			toggle_asset_menu()
			return
		if _assets_menu:
			if Input.is_key_pressed(KEY_1):
				asset_has_been_selected("wood")
			return

func toggle_build_menu():
	_building = !_building
	building_menu.set_visible(_building)
	build_selected.emit(_building)
	if !_building:
		selected_tile_changed.emit(null)

func toggle_asset_menu():
	_assets_menu = !_assets_menu
	asset_menu.set_visible(_assets_menu)

func _on_ui_update(data):
	_data = data
	money_label.text = "Money: " + str(data.money) + "$"
	owned_land_label.text = "Owned Land: " + str(data.owned_land)

func _on_selected_tile_changed(tile):
	if tile == null:
		selected_menu.set_visible(false)
		return
	match tile:
		LAND:
			selected_label.text = "Selected: Land"
			price_label.text = "Price: " + str(_data["land_price"]) + "$"
		TREE_FARM:
			selected_label.text = "Selected: Tree Farm"
			price_label.text = "Price: 100$"
	selected_menu.set_visible(true)

func _on_game_assets_update(assets):
	_assets = assets
	wood_label.text = "1: Wood: " + str(_assets["wood"])

func asset_has_been_selected(asset):
	if asset == "wood":
		asset_selection_menu.set_visible(true)
		asset_menu_selected.emit("wood", _assets, _data)


func _on_asset_menu_has_been_sold(assets, data):
	_assets = assets
	_data = data
	_on_ui_update(_data)
	asset_selection_menu.set_visible(false)


func _on_asset_menu_has_canceled():
	asset_selection_menu.set_visible(false)
