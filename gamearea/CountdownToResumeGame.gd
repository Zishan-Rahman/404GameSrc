extends Node

#the countdown scene, to be loaded after the game is told to resume, and before the game itself resumes

#slightly easier way to access the timer and label scene
onready var timer:= $Timer
onready var label:= $Label

func _ready(): #when the scene is loaded, start the timer
	timer.start()

func _process(_delta): #while the scene's running, update the label's text
	label.text = str(int(timer.time_left) + 1)

func get_timer(): #when called, get the timer so the waiting can be processed
	return timer

func _on_Timer_timeout(): #when the timer finishes, destroy
	queue_free()
