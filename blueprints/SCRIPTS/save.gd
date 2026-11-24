extends Node2D

var placed_items: Array[Dictionary] = []
var placed_circles: Array[Dictionary] = []
var placed_labels: Array[Node] = []

func _draw() -> void:
	# Rectangles and freehand drawings
	for item in placed_items:
		draw_rect(
			Rect2(item["position"], item["size"]),
			item["color"]
		)

	# Circles
	for item in placed_circles:
		var center = item["position"] + item["size"] / 2.0
		var radius = item["size"] / 2.0

		draw_set_transform(center, 0, radius)
		draw_arc(Vector2.ZERO,1.0,0,TAU,64,item["color"],3.0)
		draw_set_transform(Vector2.ZERO)
