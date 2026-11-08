
extends Node2D

signal movement
signal stopCamera

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
	DRAW,
	CIRCLE
}

var current_mode: ToolMode = ToolMode.DRAW

var placed_labels: Array[Dictionary] = []
var label_text: String = "New Label"

var drawing_rectangle: bool = false
var rectangle_start: Vector2 = Vector2.ZERO
var rectangle_end: Vector2 = Vector2.ZERO

var placed_circles: Array[Dictionary] = []

var drawing_circle: bool = false
var circle_start: Vector2 = Vector2.ZERO
var circle_end: Vector2 = Vector2.ZERO

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
		drawing_rectangle = false
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
				var text_scene = preload("res://SCENES/text.tscn")
				#var room_scene = preload("res://SCENES/room.tscn")
				var instance = text_scene.instantiate()
				instance.update_color(color)
				instance.update_position(preview_position)
				instance.update_pretext(label_text)
				instance.continue_moving.connect(continueMoving)
				instance.stop_moving.connect(stopMoving)
				add_child(instance)
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
		elif current_mode == ToolMode.CIRCLE:
			if event.pressed:
				drawing_circle = true
				circle_start = preview_position
				circle_end = circle_start
			else:
				if drawing_circle:
					drawing_circle = false
					var circle_position := Vector2(
						minf(circle_start.x, circle_end.x),
						minf(circle_start.y, circle_end.y)
					)
					var circle_size := Vector2(
						absf(circle_end.x - circle_start.x),
						absf(circle_end.y - circle_start.y)
					)
					if circle_size.x > 0 and circle_size.y > 0:
						placed_circles.append({
							"position": circle_position,
							"size": circle_size,
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
	elif (event is InputEventMouseMotion or event is InputEventKey) and drawing_circle:
		circle_end = preview_position
		queue_redraw()


func _draw() -> void:
	for line in finished_lines:
		if line.size() > 1:
			draw_polyline(line, Color.RED, 3.0, true)
	if current_line.size() > 1:
		draw_polyline(current_line, Color.RED, 3.0, true)
	for item in placed_items:
		draw_rect(Rect2(item["position"], item["size"]), item["color"])
	for item in placed_circles:
		var center = item["position"] + item["size"] / 2.0
		var radius = item["size"] / 2.0
		draw_set_transform(center, 0, radius)
		draw_arc(
			Vector2.ZERO,
			1.0,
			0,
			TAU,
			64,
			item["color"],
			3.0,
		)
		draw_set_transform(Vector2.ZERO)
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
	if drawing_circle:
		var circle_position = Vector2(
			minf(circle_start.x, circle_end.x),
			minf(circle_start.y, circle_end.y)
		)
		var circle_size = Vector2(
			absf(circle_end.x - circle_start.x),
			absf(circle_end.y - circle_start.y)
		)
		draw_set_transform(circle_position + circle_size / 2.0, 0, circle_size / 2.0)
		draw_arc(
			Vector2.ZERO,
			1.0,
			0,
			TAU,
			64,
			color,
			3.0,
			false
		)
		draw_set_transform(Vector2.ZERO)
	
	draw_rect(
		Rect2(preview_position, ITEM_SIZE),
		Color(0.2, 0.7, 0.3, 0.5)
	)

func continueMoving() -> void:
	movement.emit()
	
func stopMoving() -> void:
	stopCamera.emit()

func _on_toolbar_changed_color(newColor: Variant) -> void:
	color = newColor
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
	


func _on_toolbar_circ_mode() -> void:
	current_mode = ToolMode.CIRCLE
	pass # Replace with function body.
