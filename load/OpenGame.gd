extends Control

#in this scene, the next scene will be the game scene
#this scene will show when the game actually starts

export var next_scene: PackedScene #the next scene to be loaded

func _on_Button_pressed(): #when the play button is pressed, load the next scene
	get_tree().change_scene_to(next_scene)
