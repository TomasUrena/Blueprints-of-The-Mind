
extends Camera2D

@export var move_speed: float = 500.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

const ROOM_SIZE: Vector2 = Vector2(10000,10000)

func _ready() -> void:
	position = ROOM_SIZE / 2

var sprint: float = 1.25
var sprinting: bool = false

func _process(delta: float) -> void:
	var direction := Vector2.ZERO

	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1

	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1

	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1

	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1

	if direction != Vector2.ZERO:
		position += direction.normalized() * move_speed * delta
		
	if Input.is_action_pressed("Sprint"):
		move_speed = 1000
	else:
		move_speed = 500


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom + Vector2.ONE * zoom_speed).clamp(
				Vector2.ONE * min_zoom,
				Vector2.ONE * max_zoom
			)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom - Vector2.ONE * zoom_speed).clamp(
				Vector2.ONE * min_zoom,
				Vector2.ONE * max_zoom
			)
