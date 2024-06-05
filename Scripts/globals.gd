extends Node

var secret_number: int
var max_score: int = 0
var minimum_secret: int = 1
var maximum_secret: int = 100
var score: int = maximum_secret / 5

const save_file = "user://savegame.save"

func _ready():
	var rand = RandomNumberGenerator.new()
	secret_number = rand.randi_range(minimum_secret, maximum_secret)
	load_game()

func save():
	var save_dict = {
		"Score": score,
		"SecretNumber": secret_number,
		"MaxScore": max_score,
		"MaximumSecret": maximum_secret
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open(save_file, FileAccess.WRITE)
	var json_string = JSON.stringify(save())
	save_game.store_line(json_string)
	print(json_string)

func load_game():
	if !FileAccess.file_exists(save_file):
		return
	
	var save_game = FileAccess.open(save_file, FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if parse_result != OK:
			print("Failed to parse JSON:", json_string)
			continue
		var node_data = json.get_data()
		print(node_data)
		score = node_data["Score"]
		secret_number = node_data["SecretNumber"]
		max_score = node_data["MaxScore"]
		maximum_secret = node_data["MaximumSecret"]

func quit():
	save_game()
	get_tree().quit()
