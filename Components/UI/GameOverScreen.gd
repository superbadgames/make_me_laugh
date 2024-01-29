extends Popup


func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://Boards/StartScreen/StartScreen.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
