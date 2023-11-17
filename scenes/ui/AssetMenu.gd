extends CanvasLayer

var _data = {}
var _assets = {}
var _asset = {}

signal has_been_sold(assets, data)
signal has_canceled

@onready var amount_line: LineEdit = %AmountLine

func clear_amount():
	amount_line.clear()

func _ready():
	pass

func _on_hud_asset_menu_selected(asset, assets, data):
	_asset = asset
	_assets = assets
	_data = data


func add_money(amount):
	match _asset:
		"wood":
			_data["money"] += amount * 0.15

func _on_confirm_button_pressed():
	var amount = int(amount_line.text)
	if _assets[_asset] < amount:
		return
	_assets[_asset] -= amount
	add_money(amount)
	has_been_sold.emit(_assets, _data)
	clear_amount()


func _on_cancel_button_pressed():
	has_canceled.emit()
	clear_amount()


func _on_sell_all_pressed():
	if _assets[_asset] <= 0:
		return
	var amount = _assets[_asset]
	add_money(amount)
	_assets[_asset] -= amount
	has_been_sold.emit(_assets, _data)
	clear_amount()
