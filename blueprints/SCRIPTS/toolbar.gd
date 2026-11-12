extends Control

signal changedColor(Color)
signal textMode
signal drawMode
signal rectMode
signal circMode
signal save(String)

@onready var save_file_dialog: FileDialog = $FileDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FileDialog.visible = false 
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func _on_circle_pressed() -> void:
	circMode.emit()
	pass # Replace with function body.

func _on_save_pressed() -> void:
	$FileDialog.visible = true
	save_file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	save_file_dialog.current_file = "my_design.png" 
	pass # Replace with function body.

func _on_file_dialog_confirmed() -> void:
	save.emit(save_file_dialog.current_path)
	pass # Replace with function body.
