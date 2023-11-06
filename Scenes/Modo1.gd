extends Node2D

@onready var transicion = $Transicion

var borde: Array
var Jugador: String
var Ganador : bool = false
var Final : bool = false
var Empate : bool = false

var Esperando = load("res://Sprites/Idle.png")
var Determinacion = load("res://Sprites/Cross.png")
var Integridad = load("res://Sprites/Circle.png")

var D_Pierde = load("res://Sprites/Red_H_br.png")
var I_Pierde = load("res://Sprites/Blue_H_br.png")

func iniciar_borde()-> void:
	borde = [
		"0", "0", "0",
		"0", "0", "0",
		"0", "0", "0"
	]
	
	$Zona/Borde/Fila0/Boton0.texture_normal = Esperando
	$Zona/Borde/Fila0/Boton1.texture_normal = Esperando
	$Zona/Borde/Fila0/Boton2.texture_normal = Esperando
	$Zona/Borde/Fila1/Boton3.texture_normal = Esperando
	$Zona/Borde/Fila1/Boton4.texture_normal = Esperando
	$Zona/Borde/Fila1/Boton5.texture_normal = Esperando
	$Zona/Borde/Fila2/Boton6.texture_normal = Esperando
	$Zona/Borde/Fila2/Boton7.texture_normal = Esperando
	$Zona/Borde/Fila2/Boton8.texture_normal = Esperando
	
	Final = false
	Ganador = false
	
func Iniciar_Jugador() -> void:
	Jugador = "Determinacion"
	$Deter/EstadoD.show()
	$Inter/EstadoI.hide()
	
func Actualizar_Jugador() -> void:
	if Jugador == "Determinacion":
		if Ganador == true:
			$Inter/EstadoI.hide()
			$Inter/TextureRect.texture = I_Pierde
			$Deter/EstadoD.text = "GANASTE"
		elif Empate == true:
			$Inter/EstadoI.hide()
			$Deter/EstadoD.hide()
		else:
			Jugador = "Integridad"
			$Inter/EstadoI.show()
			$Deter/EstadoD.hide()
	else:
		if Ganador == true:
			$Deter/EstadoD.hide()
			$Deter/TextureRect.texture = D_Pierde
			$Inter/EstadoI.text = "GANASTE"
		elif Empate == true:
			$Inter/EstadoI.hide()
			$Deter/EstadoD.hide()
		else:
			Jugador = "Determinacion"
			$Deter/EstadoD.show()
			$Inter/EstadoI.hide()
	
func _ready() -> void:
	transicion.play("fade_in")
	$Transicion/Audio_T.play(1.9)
	$FindelJuego.hide()
	iniciar_borde()
	Iniciar_Jugador()
	
func Emparejamiento_Fila() -> bool:
	var compensacion = 0
	for fila in range(3):
		for indice in range(0 + compensacion, 3 + compensacion):
			if borde[indice] == Jugador:
				Ganador = true
			else:
				Ganador = false
				break
		if Ganador:
			return true
		compensacion += 3
	return false
		
func Emparejamiento_Columna() -> bool:
	var compensacion = 0
	for fila in range(3):
		for indice in range(0 + compensacion, 7 + compensacion, 3):
			if borde[indice] == Jugador:
				Ganador = true
			else:
				Ganador = false
				break
		if Ganador:
			return true
		compensacion += 1
	return false

func Emparejamiento_Diagonal() -> bool:
	for i in range(0, 9, 4):
		if borde[i] == Jugador:
			Ganador = true
		else:
			Ganador = false
			break
	if Ganador:
		return true
	for j in range(2, 7, 2):
		if borde[j] == Jugador:
			Ganador = true
		else:
			Ganador = false
			break
	if Ganador:
		return true	
	return false
	
func _process(_delta):
	if Ganador || Empate:
		$PVP.stop()
		

func Juego_lleno() -> bool:
	if borde.has("0"):
		return false
	return true
	
func checar_final() -> void:
	if Emparejamiento_Fila() || Emparejamiento_Columna() || Emparejamiento_Diagonal():
		Final = true
		$Break.play(0.33)
		Volver_Inicio()
	elif Juego_lleno():
		Final = true
		Empate = true
		Volver_Inicio()
		
func Volver_Inicio() -> void:
	if Empate:
		$FindelJuego.show()
		$Draw.play()
	else:
		$FindelJuego.show()
		$FindelJuego/Empate.hide()

func Movimiento(indice: int) -> void:
	borde[indice] = Jugador
	checar_final()
	
func Casilla_Libre(indice: int) -> bool:
	if borde[indice] == "0":
		return true
	return false
	
func Actualizar_borde(fila: int, indice: int) -> void:
	var path = "Zona/Borde/Fila" + str(fila) + "/Boton" + str(indice)
	if Jugador == "Determinacion":
		get_node(path).texture_normal = Determinacion
	elif Jugador == "Integridad":
		get_node(path).texture_normal = Integridad
	Actualizar_Jugador()

"""func _ready():
	Talla_Zona = $Zona.texture.get_width()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Para verificar si el cursor está zobre la zona del juego
			if event.position.x < Talla_Zona and event.position.x > Talla_Zona:
				print(event.position)
"""


func _on_boton_0_button_up() -> void:
	if Casilla_Libre(0) && !Final:
		Movimiento(0)
		Actualizar_borde(0,0)

func _on_boton_1_button_up() -> void:
	if Casilla_Libre(1) && !Final:
		Movimiento(1)
		Actualizar_borde(0,1)

func _on_boton_2_button_up() -> void:
	if Casilla_Libre(2) && !Final:
		Movimiento(2)
		Actualizar_borde(0,2)

func _on_boton_3_button_up() -> void:
	if Casilla_Libre(3) && !Final:
		Movimiento(3)
		Actualizar_borde(1,3)

func _on_boton_4_button_up() -> void:
	if Casilla_Libre(4) && !Final:
		Movimiento(4)
		Actualizar_borde(1,4)
		
func _on_boton_5_button_up() -> void:
	if Casilla_Libre(5) && !Final:
		Movimiento(5)
		Actualizar_borde(1,5)

func _on_boton_6_button_up() -> void:
	if Casilla_Libre(6) && !Final:
		Movimiento(6)
		Actualizar_borde(2,6)

func _on_boton_7_button_up() -> void:
	if Casilla_Libre(7) && !Final:
		Movimiento(7)
		Actualizar_borde(2,7)

func _on_boton_8_button_up() -> void:
	if Casilla_Libre(8) && !Final:
		Movimiento(8)
		Actualizar_borde(2,8)

func _on_volver_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func _on_temporizador_timeout():
	$PVP.play()

func _on_reiniciar_button_up():
	get_tree().reload_current_scene()
