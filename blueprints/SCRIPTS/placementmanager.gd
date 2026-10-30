
extends Node2D

const CELL_SIZE: int = 32
const ROOM_SIZE: Vector2 = Vector2(10000, 10000)
const METERS_PER_CELL: float = 0.5
const ITEM_SIZE: Vector2 = Vector2(32, 32)

var placed_items: Array[Dictionary] = []
var preview_position: Vector2 = Vector2.ZERO

var current_line: PackedVector2Array = []
var finished_lines: Array[PackedVector2Array] = []
var _pressed: bool = false

@onready var hud = $"../HUD"

var color: Color

enum ToolMode {
	RECTANGLE,
	TEXT,
	DRAW
}

var current_mode: ToolMode = ToolMode.DRAW

var placed_labels: Array[Dictionary] = []
var label_text: String = "New Label"

var drawing_rectangle: bool = false
var rectangle_start: Vector2 = Vector2.ZERO
var rectangle_end: Vector2 = Vector2.ZERO

func _ready() -> void:
	hud.update_room_size(
		ROOM_SIZE.x / CELL_SIZE * METERS_PER_CELL,
		ROOM_SIZE.y / CELL_SIZE * METERS_PER_CELL
	)


func _process(_delta: float) -> void:
	var mouse_pos := get_local_mouse_position()
	preview_position = Vector2(
		floor(mouse_pos.x / CELL_SIZE) * CELL_SIZE,
		floor(mouse_pos.y / CELL_SIZE) * CELL_SIZE
	)
	preview_position.x = clampf(
		preview_position.x, 0.0,
		ROOM_SIZE.x - ITEM_SIZE.x
	)
	preview_position.y = clampf(
		preview_position.y, 0.0,
		ROOM_SIZE.y - ITEM_SIZE.y
	)
	queue_redraw()


func _input(event: InputEvent) -> void:
	if get_viewport().gui_get_hovered_control() != null:
		_pressed = false
		return
	if event is InputEventMouseButton:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		if current_mode == ToolMode.RECTANGLE:
			if event.pressed:
				drawing_rectangle = true
				rectangle_start = preview_position
				rectangle_end = rectangle_start
			else:
				if drawing_rectangle:
					drawing_rectangle = false
					var rect_position := Vector2(
						minf(rectangle_start.x, rectangle_end.x),
						minf(rectangle_start.y, rectangle_end.y)
					)
					var rect_size := Vector2(
						absf(rectangle_end.x - rectangle_start.x),
						absf(rectangle_end.y - rectangle_start.y)
					)
					if rect_size.x > 0 and rect_size.y > 0:
						placed_items.append({
							"position": rect_position,
							"size": rect_size,
							"color": color
						})
					queue_redraw()
		elif current_mode == ToolMode.TEXT:
			if event.pressed:
				placed_labels.append({
					"position": preview_position,
					"text": label_text,
					"color": color
				})

				queue_redraw()
		elif current_mode == ToolMode.DRAW:
			if event.pressed:
				_pressed = true
				current_line.clear()
				current_line.append(get_local_mouse_position())
			else:
				_pressed = false
				if current_line.size() > 1:
					finished_lines.append(current_line.duplicate())
				current_line.clear()
			placed_items.append({
							"position": preview_position,
							"size": ITEM_SIZE,
							"color": color
						})
			queue_redraw()
	elif (event is InputEventMouseMotion or event is InputEventKey) and _pressed:
		var point := get_local_mouse_position()
		placed_items.append({
							"position": preview_position,
							"size": ITEM_SIZE,
							"color": color
						})
		if current_line.is_empty() or point.distance_to(current_line[-1]) >= 2.0:
			current_line.append(point)
		queue_redraw() 
	elif (event is InputEventMouseMotion or event is InputEventKey) and drawing_rectangle:
		rectangle_end = preview_position
		queue_redraw()


func _draw() -> void:
	for line in finished_lines:
		if line.size() > 1:
			draw_polyline(line, Color.RED, 3.0, true)
	if current_line.size() > 1:
		draw_polyline(current_line, Color.RED, 3.0, true)
	for item in placed_items:
		draw_rect(Rect2(item["position"], item["size"]), item["color"])
	for label in placed_labels:
		draw_string(
			ThemeDB.fallback_font,
			label["position"],
			label["text"],
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			20,
			label["color"]
		)
	if drawing_rectangle:
		var rect_position := Vector2(
			minf(rectangle_start.x, rectangle_end.x),
			minf(rectangle_start.y, rectangle_end.y)
		)

		var rect_size := Vector2(
			absf(rectangle_end.x - rectangle_start.x),
			absf(rectangle_end.y - rectangle_start.y)
		)

		draw_rect(
			Rect2(rect_position, rect_size),
			Color(color.r, color.g, color.b, 0.5)
		)
	draw_rect(
		Rect2(preview_position, ITEM_SIZE),
		Color(0.2, 0.7, 0.3, 0.5)
	)


func _on_toolbar_changed_color(Color: Variant) -> void:
	color = Color
	pass # Replace with function body.


func _on_toolbar_draw_mode() -> void:
	current_mode = ToolMode.DRAW
	pass # Replace with function body.


func _on_toolbar_text_mode() -> void:
	current_mode = ToolMode.TEXT
	pass # Replace with function body.


func _on_toolbar_rect_mode() -> void:
	current_mode = ToolMode.RECTANGLE
	pass # Replace with function body.
