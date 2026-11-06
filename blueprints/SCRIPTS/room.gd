extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_placementmanager_movement() -> void:
	$CAMERA.continueMoving()
	pass # Replace with function body.


func _on_placementmanager_stop_camera() -> void:
	$CAMERA.stopMoving()
	pass # Replace with function body.
