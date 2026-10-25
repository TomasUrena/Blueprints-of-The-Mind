extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const COLUMNS = 7
const ROWS = 6

func _draw():
	var grid_size = Vector2(100, 100)
	var cell_size = 32
	
	# Draw horizontal lines
	for i in range(grid_size.y + 1):
		draw_line(Vector2(0, i * cell_size), Vector2(grid_size.x * cell_size, i * cell_size), Color.BLUE, 1.0)
		
	# Draw vertical lines
	for i in range(grid_size.x + 1):
		draw_line(Vector2(i * cell_size, 0), Vector2(i * cell_size, grid_size.y * cell_size), Color.BLUE, 1.0)
