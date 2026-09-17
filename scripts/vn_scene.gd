extends Control

# --- Simple dialogue system for MVP ---
# Each entry: speaker, text, left_char, right_char, background, choices (optional array of {text, next_id})

var dialogue := [
	{
		"id": 0,
		"speaker": "Narrator",
		"text": "Академия ниндзя. Утро. Сегодня выпускной день.",
		"left": "", "right": "",
		"background": "courtyard",
		"next": 1
	},
	{
		"id": 1,
		"speaker": "Sensei",
		"text": "Эй, новичок. Подойди-ка сюда.",
		"left": "Sensei", "right": "",
		"background": "courtyard",
		"next": 2
	},
	{
		"id": 2,
		"speaker": "Sensei",
		"text": "Ты прошёл академию. Теперь ты генин. Но путь шиноби только начинается.",
		"left": "Sensei", "right": "",
		"background": "courtyard",
		"next": 3
	},
	{
		"id": 3,
		"speaker": "Sensei",
		"text": "Что будешь делать первым делом?",
		"left": "Sensei", "right": "",
		"background": "courtyard",
		"choices": [
			{"text": "Взять миссию D-ранга", "next": 4},
			{"text": "Потренироваться ещё", "next": 7},
			{"text": "Просто погулять по деревне", "next": 10}
		]
	},
	# Path A — Mission
	{
		"id": 4,
		"speaker": "Sensei",
		"text": "Хорошо. Есть простая задача — помочь старику с огородом. Не геройствуй.",
		"left": "Sensei", "right": "",
		"background": "gate",
		"next": 5
	},
	{
		"id": 5,
		"speaker": "Narrator",
		"text": "Ты отправляешься на миссию. Пока всё спокойно...",
		"left": "", "right": "",
		"background": "gate",
		"next": 6
	},
	{
		"id": 6,
		"speaker": "Narrator",
		"text": "Конец пролога.\n\n(Миссия D-ранга пройдена. Позже здесь будет настоящий сюжет.)",
		"left": "", "right": "",
		"background": "gate",
		"next": -1
	},
	# Path B — Training
	{
		"id": 7,
		"speaker": "Sensei",
		"text": "Умный выбор. Сила без практики — ничто.",
		"left": "Sensei", "right": "",
		"background": "terrace",
		"next": 8
	},
	{
		"id": 8,
		"speaker": "Narrator",
		"text": "Ты проводишь день на тренировочном поле. Пот, боль, прогресс.",
		"left": "", "right": "",
		"background": "terrace",
		"next": 9
	},
	{
		"id": 9,
		"speaker": "Narrator",
		"text": "Конец пролога.\n\n(Ты стал чуть сильнее. Позже здесь будет настоящий сюжет.)",
		"left": "", "right": "",
		"background": "terrace",
		"next": -1
	},
	# Path C — Walk
	{
		"id": 10,
		"speaker": "Sensei",
		"text": "Хм... Ладно. Но не забывай, что мир шиноби не прощает беспечности.",
		"left": "Sensei", "right": "",
		"background": "gate",
		"next": 11
	},
	{
		"id": 11,
		"speaker": "Narrator",
		"text": "Ты бродишь по улицам. Видишь знакомые лица... и кое-кого подозрительного в тени.",
		"left": "", "right": "",
		"background": "gate",
		"next": 12
	},
	{
		"id": 12,
		"speaker": "Narrator",
		"text": "Конец пролога.\n\n(Ты заметил что-то важное. Позже здесь будет настоящий сюжет.)",
		"left": "", "right": "",
		"background": "gate",
		"next": -1
	},
]

var current_id: int = 0
var dialogue_map: Dictionary = {}

@onready var name_label: Label = $DialogueBox/NameLabel
@onready var text_label: RichTextLabel = $DialogueBox/TextLabel
@onready var choices_container: VBoxContainer = $DialogueBox/ChoicesContainer
@onready var continue_hint: Label = $DialogueBox/ContinueHint
@onready var background: TextureRect = $Background
@onready var left_char: TextureRect = $Characters/LeftChar
@onready var right_char: TextureRect = $Characters/RightChar
@onready var left_label: Label = $Characters/LeftChar/Label
@onready var right_label: Label = $Characters/RightChar/Label


func _ready() -> void:
	for entry in dialogue:
		dialogue_map[entry.id] = entry
	_show_entry(0)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_SPACE or event.keycode == KEY_ENTER:
			_try_advance()
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Click anywhere on dialogue box to advance (if no choices)
		if choices_container.get_child_count() == 0:
			_try_advance()


func _try_advance() -> void:
	var entry = dialogue_map.get(current_id)
	if entry == null:
		return
	if entry.has("choices") and entry.choices.size() > 0:
		return  # waiting for choice
	var next_id = entry.get("next", -1)
	if next_id == -1:
		_end_prologue()
	else:
		_show_entry(next_id)


func _show_entry(id: int) -> void:
	current_id = id
	var entry = dialogue_map.get(id)
	if entry == null:
		_end_prologue()
		return

	# Clear previous choices
	for child in choices_container.get_children():
		child.queue_free()

	# Speaker & text
	name_label.text = entry.speaker
	text_label.text = entry.text
	_update_background(entry.get("background", "courtyard"))

	# Characters (simple colored dummies)
	_update_character(left_char, left_label, entry.get("left", ""))
	_update_character(right_char, right_label, entry.get("right", ""))

	# Choices or continue hint
	if entry.has("choices") and entry.choices.size() > 0:
		continue_hint.visible = false
		for choice in entry.choices:
			var btn = Button.new()
			btn.text = choice.text
			btn.custom_minimum_size = Vector2(0, 40)
			btn.pressed.connect(_on_choice_selected.bind(choice.next))
			choices_container.add_child(btn)
	else:
		continue_hint.visible = true
		continue_hint.text = "[Пробел / ЛКМ — далее]" if entry.get("next", -1) != -1 else "[Конец пролога]"


func _update_background(background_name: String) -> void:
	var textures := {
		"courtyard": preload("res://assets/backgrounds/academy_morning_courtyard.svg"),
		"gate": preload("res://assets/backgrounds/academy_morning_gate.svg"),
		"terrace": preload("res://assets/backgrounds/academy_morning_terrace.svg"),
	}
	var next_texture: Texture2D = textures.get(background_name, textures.courtyard)
	if background.texture == next_texture:
		return
	var tween := create_tween()
	tween.tween_property(background, "modulate", Color(1, 1, 1, 0), 0.1)
	tween.tween_callback(func() -> void: background.texture = next_texture)
	tween.tween_property(background, "modulate", Color.WHITE, 0.2)


func _update_character(rect: TextureRect, label: Label, name: String) -> void:
	if name == "" or name == null:
		rect.visible = false
		return
	rect.visible = true
	label.text = name
	match name:
		"Sensei":
			rect.texture = preload("res://assets/characters/ujito_sensei.svg")
		"Player":
			rect.texture = null
		_:
			rect.texture = null


func _on_choice_selected(next_id: int) -> void:
	_show_entry(next_id)


func _end_prologue() -> void:
	# Simple return to menu after short delay or immediately
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
