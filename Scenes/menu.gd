extends Control

@onready var transicion = $Transicion
var Modo1 = load("res://Scenes/Modo1.tscn")
var Modo2 = load("res://Scenes/Modo2.tscn")
var PVP = false
var PVE = false

func _on_el_gato_pressed():
	pass # Replace with function body.


func _on_pvp_pressed():
	PVP = true
	route()

func _on_pve_pressed():
	PVE = true
	route()

func route():
	$Start_Menu.stop()
	transicion.play("fade_out")
	$Transicion/Audio_T.play()

func _on_salir_pressed():
	get_tree().quit()


func _on_transicion_animation_finished(anim_name):
	if PVP:
		get_tree().change_scene_to_packed(Modo1)
	elif PVE:
		get_tree().change_scene_to_packed(Modo2)
