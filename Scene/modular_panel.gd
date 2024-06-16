extends Control

var test_code = """
age = int(input("Enter age: "))
if age >= 15:
	print("You can see the movie!")
"""

@onready var code_line_holder: VBoxContainer = %CodeLineHolder
var missing_keyword : Control

@onready var moveable_panel_scene:= preload("res://Scene/moveable_panel.tscn")
@onready var fillable_palen := preload("res://Scene/fillable_panel.tscn")

const keywords =  [
		"False", "None", "True", "and", "as", "assert", "async", "await", "break", 
		"class", "continue", "def", "del", "elif", "else", "except", "finally", 
		"for", "from", "global", "if", "import", "in", "is", "lambda", "nonlocal", 
		"not", "or", "pass", "raise", "return", "try", "while", "with", "yield",
		"abs", "all", "any", "ascii", "bin", "bool", "bytearray", "bytes", "callable", 
		"chr", "classmethod", "compile", "complex", "delattr", "dict", "dir", "divmod", 
		"enumerate", "eval", "exec", "filter", "float", "format", "frozenset", "getattr", 
		"globals", "hasattr", "hash", "help", "hex", "id", "input", "int", "isinstance", 
		"issubclass", "iter", "len", "list", "locals", "map", "max", "memoryview", "min", 
		"next", "object", "oct", "open", "ord", "pow", "print", "property", "range", 
		"repr", "reversed", "round", "set", "setattr", "slice", "sorted", "staticmethod", 
		"str", "sum", "super", "tuple", "type", "vars", "zip", "__import__"
	]

var used_keywords = {}

enum Tokens {
	OPERATOR,
	WORD,
	BRACKET,
	NULL
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for line in test_code.split("\n"):
		generate_code_line(line)
	missing_keyword = used_keywords.keys().pick_random()
	var fillable_panel = fillable_palen.instantiate()
	missing_keyword.add_sibling(fillable_panel)
	fillable_panel.set_target(used_keywords[missing_keyword])
	fillable_panel.target_word_entered.connect(
		func ():
			print("TARGET ACHIEVED")
			missing_keyword.show()
			fillable_panel.hide()
	)
	missing_keyword.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Input - Array of strings, representing a line of code
func generate_code_line(line):
	if line == "":
		return
	var hbox := HBoxContainer.new()
	if line.begins_with("\t"):
		var index = 0
		while line[index] == "\t":
			index += 1
			var spacer := hbox.add_spacer(false)
			spacer.custom_minimum_size.x = get_theme_default_font_size()*4
			spacer.size_flags_horizontal = Control.SIZE_FILL
	var line_list = split_line(line)
	print(line_list)
	code_line_holder.add_child(hbox)
	for block in line_list:
		if not block:
			continue
		var panel := moveable_panel_scene.instantiate()
		if block in keywords:
			if block not in used_keywords:
				used_keywords[panel] = block
		panel.get_node("%Label").text = block
		hbox.add_child(panel)

func check_regex(text, expr):
	var regex = RegEx.new()
	regex.compile(expr)
	if regex.search(text):
		return true
	else:
		return false

func isalpha(text):
	return check_regex(text, "[A-Za-z]")

func issymbol(text):
	return check_regex(text, "[^\\w\\s]")

func isdigit(text):
	return check_regex(text, "[0-9]")
	
func isbracket(text):
	return check_regex(text, "[\\[\\]{}()\"]")

func isoperator(text):
	return check_regex(text, "[*-+=<>/]")

func get_token_type(cha):
	if isbracket(cha):
		return Tokens.BRACKET
	elif isoperator(cha):
		return Tokens.OPERATOR
	elif isalpha(cha):
		return Tokens.WORD
	else:
		return Tokens.NULL

func split_line(line):
	var line_list := []
	var proc_line := ""
	var is_string = false
	for i in range(len(line)-1):
		var cur_cha = line[i]
		var next_cha = line[i+1]
		proc_line += cur_cha
		if next_cha == " ":
			continue
		if cur_cha == "\"" or cur_cha == "'":
			is_string = !is_string
			proc_line += " "
		if is_string:
			continue
		if isalpha(cur_cha) or isdigit(cur_cha):
			if issymbol(next_cha):
				proc_line += " "
		elif issymbol(cur_cha):
			if cur_cha in "<>*+-/=!":
				if next_cha == "=":
					continue
				else:
					proc_line += " "
			else:
				proc_line += " "
	proc_line += line.right(1)
	print(proc_line)
	return proc_line.split(" ")

"""func split_line(line):
	var line_list := []
	var current_string := ""
	var current_string_token = Tokens.NULL
	var ignore = false
	for cha in line:
		var append_flag = false
		var next_cha_token = get_token_type(cha)
		if cha == " ":
			if current_string:
				append_flag = true
			current_string_token = Tokens.NULL
		elif cha == "\"":
			ignore = !ignore
		elif ignore:
			
		else:
			if current_string_token != next_cha_token\
			or isbracket(cha):
				append_flag = true
				current_string_token = next_cha_token
			else:
				current_string += cha
		if append_flag:
			line_list.append(current_string)
			current_string = ""
			current_string = cha
		print(line_list)
	return line_list
"""	
