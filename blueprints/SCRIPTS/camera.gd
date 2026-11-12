
extends Camera2D

@export var move_speed: float = 500.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

const ROOM_SIZE: Vector2 = Vector2(10000,10000)

var movement: bool = true

func _ready() -> void:
	position = ROOM_SIZE / 2

var sprint: float = 1.25
var sprinting: bool = false

func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	if !movement:
		return
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
		move_speed = 1500
	else:
		move_speed = 500

var dragging := false
var last_mouse_position := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_hovered_control() != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom + Vector2.ONE * zoom_speed).clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom - Vector2.ONE * zoom_speed).clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			last_mouse_position = get_global_mouse_position()
	if event is InputEventMouseMotion and dragging:
		position -= event.relative / zoom
	if event is InputEventPanGesture:
		position += event.delta / zoom 
	if event is InputEventMagnifyGesture:
		zoom = (zoom * event.factor).clamp(Vector2.ONE * min_zoom, Vector2.ONE * max_zoom)

func _on_placementmanager_stop_moving() -> void:
	movement = false
	print("SIGNAL TO CAMERA CONNECTED")
	pass # Replace with function body.
	
func continueMoving() -> void:
	movement = true
	
func stopMoving() -> void:
	movement = false
