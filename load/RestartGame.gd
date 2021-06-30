extends Control

#in this scene, the next scene will be the game scene
#this scene will show when the player hits a 4 -- GAME OVER

export (String, FILE, "*.tscn") var next_scene #doing it as a PackedScene seemed to make the game crash for some reason, so I did it this way and it works

func _ready(): #when the scene's loaded, show the score
	$VBoxContainer/ScoreLabel.text = "Score: " + str(Scoring.get_score())

func _on_Button_pressed(): #when the restart button is pressed, load the next scene
	get_tree().change_scene(next_scene)
