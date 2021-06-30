extends Area2D

#I tried doing this in the Game scene, but I got confused and it wasn't working, so it was better to do this in the hole scene itself

func _on_hole_input_event(_viewport, event, _shape_idx): #when the hole has an input event (it's clicked, in this case), do all this
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		get_parent()._on_bonk(self) #when the hole is clicked, get the parent (Game scene) and do its "_on_bonk" event, taking the hole itself as a parameter
