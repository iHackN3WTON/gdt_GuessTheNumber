extends Control

@onready var secret_number_label = $SecretNumberLabel
@onready var guess_text = $GuessText
@onready var message_label = $MessageLabel
@onready var play_again_button = $PlayAgainButton
@onready var return_button = $ReturnButton
@onready var guess_button = $GuessButton
@onready var range_label = $RangeLabel
@onready var score_label = $ScoreLabel
@onready var max_score_label = $MaxScoreLabel
@onready var quit_button = $QuitButton
@onready var message_label_2 = $MessageLabel2



# Called when the node enters the scene tree for the first time.
func _ready():
	start_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_guess_button_pressed():
	var guess = int(guess_text.text)
	
	if Globals.score >= 1:
		if guess < Globals.minimum_secret or guess > Globals.maximum_secret:
			message_label.text = "That number is not inside the range"
		elif guess != Globals.secret_number:
			message_label.text = "Your number is too " + ("high" if guess > Globals.secret_number else "low")
			Globals.score -= 1
			score_label.text = "Score: " + str(Globals.score)
			if Globals.score == 0:
				message_label.text = "Sorry you lost"
				if Globals.maximum_secret > 20:
					Globals.maximum_secret -= 20
					message_label_2.text = "You're quite slow, I will decrease range to " + str(Globals.maximum_secret)
				end_game()
		elif guess == Globals.secret_number:
			message_label.text = "That is correct!"
			
			if Globals.score > Globals.maximum_secret / 15 * 2:
				Globals.maximum_secret += 20
				message_label_2.text = "You're doing great, I will increase range to " + str(Globals.maximum_secret)
				
			if Globals.maximum_secret > 20 and Globals.score < (Globals.maximum_secret / 15):
				Globals.maximum_secret -= 20
				message_label_2.text = "You're quite slow, I will decrease range to " + str(Globals.maximum_secret)
			
			if Globals.score > Globals.max_score:
				Globals.max_score = Globals.score
			end_game()
		
		Globals.save_game()


func _on_play_again_button_pressed():
	var rand = RandomNumberGenerator.new()
	Globals.secret_number = rand.randi_range(Globals.minimum_secret, Globals.maximum_secret)
	Globals.score = Globals.maximum_secret / 5
	start_game()


func _on_return_button_pressed():
	var rand = RandomNumberGenerator.new()
	Globals.secret_number = rand.randi_range(Globals.minimum_secret, Globals.maximum_secret)
	Globals.score = Globals.maximum_secret / 5
	return_to_main()


func start_game():
	play_again_button.visible = false
	return_button.visible = false
	guess_text.visible = true
	guess_button.visible = true
	quit_button.visible = true
	score_label.text = "Score: " + str(Globals.score)
	max_score_label.text = "Max Score: " + str(Globals.max_score)
	message_label.text = ""
	message_label_2.text = ""
	secret_number_label.text = "??"
	guess_text.text = ""
	range_label.text = "(Between " + str(Globals.minimum_secret) + " and " + str(Globals.maximum_secret) + ")"
	Globals.save_game()

func end_game():
	play_again_button.visible = true
	return_button.visible = true
	guess_text.visible = false
	guess_button.visible = false
	quit_button.visible = false
	secret_number_label.text = str(Globals.secret_number)
	
func return_to_main():
	Globals.save()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_quit_button_pressed():
	return_to_main()
