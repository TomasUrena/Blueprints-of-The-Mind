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

@onready var hud = $HUD 

func _on_save_pressed() -> void:
	var path = "my_design.png"
	hud.hide()
	$PLACEMENTMANAGER.update_viewport_size()
	await RenderingServer.frame_post_draw
	var image = $SubViewportContainer/SubViewport.get_texture().get_image()
	if image.is_empty():
		print("Error: Image is empty!")
		hud.show()
		return
	var error
	if OS.has_feature("web"):
		var data
		var type
		if path.ends_with(".png"):
			data = image.save_png_to_buffer()
			type = "png"
		elif path.ends_with(".jpg") or path.ends_with(".jpeg"):
			data = image.save_jpg_to_buffer() 
			type = "jpg"
		elif path.ends_with(".webp"):
			data = image.save_webp_to_buffer()
			type = "webp"
		type = "image/" + type
		JavaScriptBridge.download_buffer(data,path,type)#,"image/png"
	else:
		if path.ends_with(".png"):
			error = image.save_png(path)
		elif path.ends_with(".jpg") or path.ends_with(".jpeg"):
			error = image.save_jpg(path) 
		elif path.ends_with(".webp"):
			error = image.save_webp(path)
		if error == OK:
			print("Image saved successfully!")
			print("Saved location: ", path)
			print("Absolute path: ", ProjectSettings.globalize_path(path))
		else: 
			print("Error saving image: ", error)
	hud.show()
	$PAINTBOX/PAINT.size = Vector2i(10000,10000)
	pass # Replace with function body.
