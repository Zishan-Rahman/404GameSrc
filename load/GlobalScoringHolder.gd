extends Node

#I made a global scene for the score, so that it can be shown in the restart scene when the game finishes (when the player hits a 4)

var score: int # the score itself

func increment_score(): #when called, increment the score by 1
	score += 1

func get_score(): #when called, get the score from this scene
	return score

func wipe_score(): #when called, set the score to zero
	score = 0
