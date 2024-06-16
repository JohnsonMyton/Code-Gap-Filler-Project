extends Control

var test_code = """
age = int(input("Enter age: ))
if age >= 15:
	print("You can see the movie!)
"""
@onready var code_text = $CodeText
@onready var fillable_gap: LineEdit = $CodeText/PanelContainer/FillableGap
@onready var panel_container: PanelContainer = $CodeText/PanelContainer


@onready var text_to_be_filled : TextToBeFilled

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	text_to_be_filled = select_text("int")
	code_text.text = test_code
	await get_tree().create_timer(.1).timeout
	text_to_be_filled.set_bounding_rect(code_text)
	panel_container.position = text_to_be_filled.rect.position + Vector2.ONE
	panel_container.size = text_to_be_filled.rect.size
	pass # Replace with function body.

func select_text(keyword):
	var start_pos = test_code.find(keyword)
	return TextToBeFilled.new(start_pos, keyword)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

class TextToBeFilled:
	var pos : int
	var text : String
	var length : int
	var end_pos : int
	var rect : Rect2
	func _init(ipos, itext):
		pos = ipos
		text = itext
		length = len(itext)
		end_pos = pos + length
	func set_bounding_rect(label:Label):
		var start_rect = label.get_character_bounds(pos)
		var end_rect = label.get_character_bounds(end_pos)
		print(start_rect, end_rect)
		rect = label.get_character_bounds(pos).merge(label.get_character_bounds(end_pos))
