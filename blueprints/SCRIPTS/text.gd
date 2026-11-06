extends Control

signal continue_moving
signal stop_moving

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color.TRANSPARENT
	$LineEdit.add_theme_stylebox_override("normal",style)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_line_edit_text_changed(new_text: String) -> void:
	stop_moving.emit()
	$LineEdit.placeholder_text = ""
	var font = $LineEdit.get_theme_font("font")
	var font_size = $LineEdit.get_theme_font_size("font_size")
	var text_width = font.get_string_size(new_text, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
	$LineEdit.custom_minimum_size.x = text_width + 20
	pass # Replace with function body.

func update_pretext(text: String) -> void:
	$LineEdit.placeholder_text = text

func update_position(newPosition: Vector2) -> void:
	$LineEdit.position = newPosition
	
func update_color(color: Color) -> void:
	$LineEdit.add_theme_color_override("font_placeholder_color", color)
	$LineEdit.add_theme_color_override("font_color", color)
	



func _on_line_edit_text_submitted(_new_text: String) -> void:
	continue_moving.emit()
	pass # Replace with function body.
