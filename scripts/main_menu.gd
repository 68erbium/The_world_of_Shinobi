extends Control


const BUTTON_HOVER_SCALE := Vector2(1.06, 1.06)
const BUTTON_PRESS_SCALE := Vector2(0.94, 0.94)
const BUTTON_NORMAL_SCALE := Vector2.ONE
const BUTTON_ANIMATION_DURATION := 0.12


func _ready() -> void:
	for button in $VBoxContainer.get_children():
		button.mouse_entered.connect(_on_button_mouse_entered.bind(button))
		button.mouse_exited.connect(_on_button_mouse_exited.bind(button))
		button.button_down.connect(_on_button_down.bind(button))
		button.button_up.connect(_on_button_up.bind(button))

	$VBoxContainer/StartButton.grab_focus()


func _animate_button(button: TextureButton, target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", target_scale, BUTTON_ANIMATION_DURATION)


func _on_button_mouse_entered(button: TextureButton) -> void:
	_animate_button(button, BUTTON_HOVER_SCALE)


func _on_button_mouse_exited(button: TextureButton) -> void:
	_animate_button(button, BUTTON_NORMAL_SCALE)


func _on_button_down(button: TextureButton) -> void:
	_animate_button(button, BUTTON_PRESS_SCALE)


func _on_button_up(button: TextureButton) -> void:
	if button.is_hovered():
		_animate_button(button, BUTTON_HOVER_SCALE)
	else:
		_animate_button(button, BUTTON_NORMAL_SCALE)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/vn_scene.tscn")


func _on_story_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_map.tscn")


func _on_ninpedia_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ninpedia.tscn")


func _on_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cards_collection.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
