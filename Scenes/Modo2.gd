extends Node2D

@onready var transicion = $Transicion

var borde : Array
var Jugador : String
var Computadora : bool = false
var Ganador : bool = false
var Final : bool = false
var Empate : bool = false
var mejor_puntaje : int
var mejor_movimiento : int
var puntaje : int

var Esperando = load("res://Sprites/Idle.png")
var Determinacion = load("res://Sprites/Cross.png")
var Gato = load("res://Sprites/Circle.png")

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
	Computadora = false
	
func Iniciar_Jugador() -> void:
	Jugador = "Determinacion"
	$Deter/EstadoD.show()
	
func Actualizar_Jugador() -> void:
	print("Cambio de jugador")
	if Jugador == "Determinacion":
		if Ganador == true:
			$Cat/TextureRect.texture = I_Pierde
			$Deter/EstadoD.text = "GANASTE"
		elif Empate == true:
			$Deter/EstadoD.hide()
		else:
			Jugador = "Gato"
			Computadora = true
			$Deter/EstadoD.hide()
	else:
		Computadora = false
		if Ganador == true:
			$Deter/EstadoD.text = "PERDISTE"
			$Deter/TextureRect.texture = D_Pierde
		elif Empate == true:
			$Deter/EstadoD.hide()
		else:
			Jugador = "Determinacion"	
			$Deter/EstadoD.show()
	
func _ready() -> void:
	transicion.play("fade_in")
	$Transicion/Audio_T.play(1.85)
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
	
func _process(delta):
	if Ganador:
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
	else:
		$FindelJuego.show()
		$FindelJuego/Empate.hide()

func Movimiento(indice: int) -> void:
	if Jugador == "Determinacion":
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
	Actualizar_Jugador()

func _on_boton_0_button_up() -> void:
	if Casilla_Libre(0) && !Final:
		Movimiento(0)
		Actualizar_borde(0,0)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_1_button_up() -> void:
	if Casilla_Libre(1) && !Final:
		Movimiento(1)
		Actualizar_borde(0,1)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_2_button_up() -> void:
	if Casilla_Libre(2) && !Final:
		Movimiento(2)
		Actualizar_borde(0,2)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_3_button_up() -> void:
	if Casilla_Libre(3) && !Final:
		Movimiento(3)
		Actualizar_borde(1,3)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_4_button_up() -> void:
	if Casilla_Libre(4) && !Final:
		Movimiento(4)
		Actualizar_borde(1,4)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_5_button_up() -> void:
	if Casilla_Libre(5) && !Final:
		Movimiento(5)
		Actualizar_borde(1,5)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_6_button_up() -> void:
	if Casilla_Libre(6) && !Final:
		Movimiento(6)
		Actualizar_borde(2,6)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_7_button_up() -> void:
	if Casilla_Libre(7) && !Final:
		Movimiento(7)
		Actualizar_borde(2,7)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_boton_8_button_up() -> void:
	if Casilla_Libre(8) && !Final:
		Movimiento(8)
		Actualizar_borde(2,8)
		if !Final && Jugador == "Gato":
			MovimientoComputadora()

func _on_volver_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

func Minimax(jugador: String) -> int:
	if JugadorGana("Gato"):
		return 1
	if JugadorGana("Determinacion"):
		return -1
	if JuegoEmpate():
		return 0
	
	if jugador == "Gato":
		mejor_puntaje = -INF
		mejor_movimiento = -1
		for i in range(9):
			if borde[i] == "0":
				borde[i] = "Gato"
				puntaje = Minimax("Determinacion")
				borde[i] = "0"
				if puntaje > mejor_puntaje:
					mejor_puntaje = puntaje
					mejor_movimiento = i
		return mejor_puntaje
	else:
		mejor_puntaje = INF
		mejor_movimiento = -1
		for i in range(9):
			if borde[i] == "0":
				borde[i] = "Determinacion"
				puntaje = Minimax("Gato")
				borde[i] = "0"
				if puntaje < mejor_puntaje:
					mejor_puntaje = puntaje
					mejor_movimiento = i
		return mejor_puntaje

func MovimientoComputadora() -> void:
	print("9")
	mejor_puntaje = -INF
	mejor_movimiento = -1
	
	for i in range(9):
		if borde[i] == "0":
			borde[i] = "Gato"
			puntaje = Minimax("Gato")
			borde[i] = "0"
			if puntaje > mejor_puntaje:
				mejor_puntaje = puntaje
				mejor_movimiento = i
			elif mejor_puntaje <= 0:
				mejor_movimiento = i
		print(puntaje, " ", i)
	print(mejor_puntaje, " Mejor puntaje")
	print(mejor_movimiento," Mejor movimiento")
	if mejor_movimiento >= 0:
		borde[mejor_movimiento] = "Gato"
		var path : String
		for i in range(9):
			if (i >= 0 && i <= 2) && mejor_movimiento == i:
				path = "Zona/Borde/Fila0/Boton" + str(i)
			elif (i >= 3 && i <= 5) && mejor_movimiento == i:
				path = "Zona/Borde/Fila1/Boton" + str(i)
			elif (i >= 6 && i <= 8) && mejor_movimiento == i:
				path = "Zona/Borde/Fila2/Boton" + str(i)	
		get_node(path).texture_normal = Gato
		Actualizar_Jugador()

func JugadorGana(jugador: String) -> bool:
	for i in range(3):
		if borde[i] == jugador && borde[i + 3] == jugador && borde[i + 6] == jugador:
			return true
	for i in range(0, 9, 3):
		if borde[i] == jugador && borde[i + 1] == jugador && borde[i + 2] == jugador:
			return true
	if (borde[0] == jugador && borde[4] == jugador && borde[8] == jugador) || (borde[2] == jugador && borde[4] == jugador && borde[6] == jugador):
		return true
	return false

func JuegoEmpate() -> bool:
	for i in range(9):
		if borde[i] == "0":
			return false 
	return true  

func _on_temporizador_timeout():
	$PVP.play()
