extends Node2D

#the scene and script for handling most of the game's logic and pause functionality

#signal(s) to be emitted
signal score_update

#easier way to access certain scenes already in the tree
onready var timer:= $Timer
onready var scorelabel:= $ScoreLabel
onready var pausebutton:= $PauseButton
onready var pauselabel:= $PauseLabel
onready var plugbutton:= $PlugButton

#preloading certain scenes and being able to add them to the tree
export (String, FILE, "*.tscn") var restart_scene
export var countdown_scene: PackedScene
var countdown: Node
export var four_scene: PackedScene
var four: Node
export var oh_scene: PackedScene
var oh: Node
var four2: Node

var hole_positions: Array #for storing the positions of each hole so that the numbers can land on them
var rangen: RandomNumberGenerator #for making the positions of each number random
var handle_p: bool = true #for determining whether or not to handle the "pause" event when P is pressed
export var wait_limit: float #for determining the limit to how fast the numbers' positions are changed
export var wait_quotient: float #for determining how fast the timer's time is decreased

func _ready(): #when the scene is loaded
	Scoring.wipe_score()
	self.connect("score_update",self,"_on_score_update")
	rangen = RandomNumberGenerator.new()
	rangen.randomize() #needs to be initialised first
	get_positions()
	create()
	set_numbs()
	timer.start()

func _input(event): #for processing input events
	if event.is_action_pressed("pause") and handle_p:
		_on_PauseButton_pressed()

func get_positions(): #gets the positions of each hole
	for hole in get_tree().get_nodes_in_group("holes"):
		hole_positions.append(hole.position)

func set_number_position(): #sets the position of a specific number
	return hole_positions[rangen.randi_range(0,len(hole_positions)-1)]

func create(): #creates the number scenes and adds them to the "hide_on_pause" group and the scene tree itself
	four = four_scene.instance()
	self.add_child(four)
	four.add_to_group("hide_on_pause") #"hide_on_pause" ensures that the numbers are hidden with everything else specified to be hidden when the game itself is paused
	oh = oh_scene.instance()
	self.add_child(oh)
	oh.add_to_group("hide_on_pause")
	four2 = four_scene.instance()
	self.add_child(four2)
	four2.add_to_group("hide_on_pause")

func set_numbs(): #sets the position(s) of each number
	four.position = set_number_position()
	oh.position = set_number_position()
	while oh.position == four.position:
		oh.position = set_number_position()
	four2.position = set_number_position()
	while four2.position == four.position or four2.position == oh.position:
		four2.position = set_number_position()

func _on_bonk(hole): #when a hole is clicked on
	if hole.position == oh.position:
		emit_signal("score_update")
		timer.emit_signal("timeout")
	elif hole.position == four.position or hole.position == four2.position:
		get_tree().change_scene(restart_scene)

func _on_Timer_timeout(): #when the timer reaches 0
	set_numbs()
	#decreases (or sets the same) the time the game waits to generate new number positions
	if timer.wait_time > wait_limit:
		timer.wait_time *= wait_quotient
	if timer.wait_time <= wait_limit:
		timer.wait_time = wait_limit
	timer.start()

func _on_score_update(): #when told to update the score, update the score
	Scoring.increment_score()
	scorelabel.text = "Score: " + str(Scoring.get_score())

func _on_PauseButton_pressed(): #when the game is told to pause
	pauselabel.visible = not pauselabel.visible
	plugbutton.visible = not plugbutton.visible
	if get_tree().paused:
		pausebutton.text = "Press P, click or tap here to Pause"
		#play the countdown scene and wait until it's finished to carry on
		countdown = countdown_scene.instance()
		self.add_child(countdown)
		pausebutton.visible = false
		scorelabel.visible = false
		handle_p = false #that way, pressing P won't replay the scene
		yield(countdown.get_timer(), "timeout") #play the scene and wait until it's finished
		pausebutton.visible = true
		scorelabel.visible = true
		handle_p = true #that way, after going back to the game, we can press P to pause again
	else:
		pausebutton.text = "Press P, click or tap here to Resume"
	for node in get_tree().get_nodes_in_group("hide_on_pause"):
		node.visible = not node.visible
	get_tree().paused = not get_tree().paused
