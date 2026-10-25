
extends CanvasLayer

@onready var room_size_label: Label = $Control/PanelContainer/VBoxContainer/RoomSize
@onready var selected_item_label: Label = $Control/PanelContainer/VBoxContainer/SelectedItem
@onready var width_label: Label = $Control/PanelContainer/VBoxContainer/WIDTH
@onready var depth_label: Label = $Control/PanelContainer/VBoxContainer/DEPTH 

func _ready() -> void:
	pass

func update_room_size(width: float, depth: float) -> void:
	var room_size_label: Label = $Control/PanelContainer/VBoxContainer/RoomSize
	room_size_label.text = str("Room: %.1f m × %.1f m" % [width, depth])

func update_selected_item(
	item_name: String,
	width: float,
	depth: float
) -> void:
	selected_item_label.text = item_name
	width_label.text = "Width: %.2f m" % width
	depth_label.text = "Depth: %.2f m" % depth

func clear_selection() -> void:
	selected_item_label.text = "No item selected"
	width_label.text = "Width: --"
	depth_label.text = "Depth: --"
