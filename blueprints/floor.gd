
extends Node2D

@export var room_size: Vector2 = Vector2(10000,10000)
@export var cell_size: int = 32

# Each grid cell represents half a meter.
@export var meters_per_cell: float = 0.5

func _draw() -> void:
	# Draw the room floor
	draw_rect(
		Rect2(Vector2.ZERO, room_size),
		Color("#e8e1d5")
	)

	# Draw vertical grid lines
	for x in range(0, int(room_size.x) + 1, cell_size):
		draw_line(
			Vector2(x, 0),
			Vector2(x, room_size.y),
			Color("#b8b2a8"),
			1.0
		)

	# Draw horizontal grid lines
	for y in range(0, int(room_size.y) + 1, cell_size):
		draw_line(
			Vector2(0, y),
			Vector2(room_size.x, y),
			Color("#b8b2a8"),
			1.0
		)
	# Show measurements every 2 cells.
	var font = ThemeDB.fallback_font
	var font_size = 12
	var step = cell_size * 2
	var label_meters = meters_per_cell * 2.0
	for x in range(0, int(room_size.x), step):
		var meters = float(x / cell_size) * meters_per_cell
		draw_string(
			font,
			Vector2(x + 3, 14),
			"%.1f m" % meters,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			Color("#514a42")
		)
	for y in range(step, int(room_size.y), step):
		var meters = float(y / cell_size) * meters_per_cell
		draw_string(
			font,
			Vector2(3, y - 3),
			"%.1f m" % meters,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			font_size,
			Color("#514a42")
		)
