extends Camera2D

var _target_zoom: float = 3.0
const MOVE_SPEED: float = 400

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if Input.is_action_just_pressed("zoom_in"):
			zoom_out()
		elif Input.is_action_just_pressed("zoom_out"):
			zoom_in()
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_RIGHT:
			position -= event.relative * zoom * 0.25
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_in()
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_out()

const MIN_ZOOM: float = 2.0
const MAX_ZOOM: float = 4.0
const ZOOM_INCREMENT: float = 0.1

func zoom_in() -> void:
	_target_zoom = max(_target_zoom - ZOOM_INCREMENT, MIN_ZOOM)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = min(_target_zoom + ZOOM_INCREMENT, MAX_ZOOM)
	set_physics_process(true)

const ZOOM_RATE: float = 8.0

func _physics_process(delta: float) -> void:
	zoom = lerp(
		zoom,
		_target_zoom * Vector2.ONE,
		ZOOM_RATE * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))
