extends Control


func _on_TestLand_1P_pressed():
	get_tree().change_scene("res://Boards/TestLand/TestLand_1_player.tscn")


func _on_TestLand_2P_pressed():
	get_tree().change_scene("res://Boards/TestLand/TestLand_2_player.tscn")


func _on_TestLand_3P_pressed():
	get_tree().change_scene("res://Boards/TestLand/TestLand_3_player.tscn")


func _on_TestLand_4P_pressed():
	get_tree().change_scene("res://Boards/TestLand/TestLand_4_player.tscn")



func _on_Level_01_p1_pressed():
	get_tree().change_scene("res://Boards/Level_00/p1_Level_00_Enter_The_Maw.tscn")


func _on_Level_01_p2_pressed():
	get_tree().change_scene("res://Boards/Level_00/p2_Level_00_Enter_The_Maw.tscn")


func _on_Level_01_p3_pressed():
	get_tree().change_scene("res://Boards/Level_00/p3_Level_00_Enter_The_Maw.tscn")


func _on_Level_01_p4_pressed():
	get_tree().change_scene("res://Boards/Level_00/p4_Level_00_Enter_The_Maw.tscn")


func _on_Quit_pressed():
	get_tree().quit()
