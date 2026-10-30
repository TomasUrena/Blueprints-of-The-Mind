extends Control

signal changedColor(Color)
signal textMode
signal drawMode
signal rectMode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_color_color_changed(color: Color) -> void:
	changedColor.emit(color)
	$COLOR/Label.add_theme_color_override("font_color", color.inverted())
	pass # Replace with function body.


func _on_text_pressed() -> void:
	textMode.emit()
	pass # Replace with function body.


func _on_draw_pressed() -> void:
	drawMode.emit()
	pass # Replace with function body.


func _on_square_pressed() -> void:
	rectMode.emit()
	pass # Replace with function body.
