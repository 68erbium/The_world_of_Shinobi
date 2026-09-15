extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_story_map_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/story_map.tscn")


func _on_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cards_collection.tscn")
