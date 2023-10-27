extends Control

func _on_el_gato_pressed():
	pass # Replace with function body.


func _on_pvp_pressed():
	get_tree().change_scene_to_file("res://Scenes/Modo1.tscn")


func _on_pve_pressed():
	pass # Replace with function body.


func _on_salir_pressed():
	get_tree().quit()
