extends "res://Scene/moveable_panel.gd"

@onready var line_edit: LineEdit = %LineEdit

var target_text : String

signal target_word_entered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.size.x = %Label.size.x
	
	pass # Replace with function body.

func set_target(target):
	target_text = target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_line_edit_text_changed(new_text: String) -> void:
	if target_text == new_text:
		target_word_entered.emit()
	pass # Replace with function body.
