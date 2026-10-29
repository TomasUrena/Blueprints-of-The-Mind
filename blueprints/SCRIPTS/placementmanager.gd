
extends Node2D

const CELL_SIZE: int = 32
const ROOM_SIZE: Vector2 = Vector2(10000,10000)
const METERS_PER_CELL: float = 0.5

# Example furniture footprint: 2 cells wide, 1 cell tall
const ITEM_SIZE: Vector2 = Vector2(32, 32)

var placed_items: Array[Vector2] = []
var preview_position: Vector2 = Vector2.ZERO

@onready var hud = $"../HUD"

func _ready() -> void:
	hud.update_room_size(ROOM_SIZE.x / CELL_SIZE * METERS_PER_CELL, ROOM_SIZE.y / CELL_SIZE * METERS_PER_CELL)

func _process(_delta: float) -> void:
	var mouse_pos = get_local_mouse_position()

	# Snap the furniture's top-left corner to the grid
	preview_position = Vector2(
		floor(mouse_pos.x / CELL_SIZE) * CELL_SIZE,
		floor(mouse_pos.y / CELL_SIZE) * CELL_SIZE
	)

	# Keep the furniture inside the room
	preview_position.x = clampf(
		preview_position.x, 0.0,
		ROOM_SIZE.x - ITEM_SIZE.x
	)
	preview_position.y = clampf(
		preview_position.y, 0.0,
		ROOM_SIZE.y - ITEM_SIZE.y
	)

	queue_redraw()

var _pressed: bool = false
func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_hovered_control() != null:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_pressed = event.pressed
			# Place a furniture item at the snapped position
			placed_items.append(preview_position)
			queue_redraw()
	elif (event is InputEventMouseMotion or event is InputEventKey) and _pressed:
		placed_items.append(preview_position)
		queue_redraw()


func _draw() -> void:
	# Draw furniture already placed
	for item_pos in placed_items:
		draw_rect(
			Rect2(item_pos, ITEM_SIZE),
			Color.BLACK
		)

	# Draw translucent placement preview
	draw_rect(
		Rect2(preview_position, ITEM_SIZE),
		Color(0.2, 0.7, 0.3, 0.5)
	)
