extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_play_prologue_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/vn_scene.tscn")


func _on_ninpedia_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ninpedia.tscn")


func _on_cards_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/cards_collection.tscn")
