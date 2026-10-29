extends Sprite2D

@onready var sprite: Sprite2D = $"."

var dragging 
var os = Vector2(0,0)

var snap = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - os
		# var newPos = get_global_mouse_position() - os
		# position = Vector2(snapped(newPos.x, snap), snapped(newPos.y, snap))
		

func _on_button_button_down() -> void:
	dragging = true
	os = get_global_mouse_position() - global_position


func _on_button_button_up() -> void:
	dragging = false

func _rotate() -> void:
	sprite.rotation_degrees += 90.0

func _vertical() -> void: 
	sprite.scale = Vector2(1, 1.5) 

func _horizontal() -> void:
	sprite.scale = Vector2(1.5, 1)
