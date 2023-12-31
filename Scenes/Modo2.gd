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
const INF = 10000

var solucion : bool = true

var Esperando = load("res://Sprites/Idle.png")
var Determinacion = load("res://Sprites/Cross.png")
var Gato = load("res://Sprites/Circle.png")

var D_Pierde = load("res://Sprites/Red_H_br.png")
var Gato_Pierde = load("res://Sprites/Gato_Lose.png")
var Gato_Gana = load("res://Sprites/Gato_Win.png")


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
			$Cat/TextureRect.texture = Gato_Pierde
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
			$Deter/EstadoD.show()
			$Deter/EstadoD.text = "PERDISTE"
			$Deter/TextureRect.texture = D_Pierde
			$Cat/TextureRect.texture = Gato_Gana
			$Draw.play()
		elif Empate == true:
			$Deter/EstadoD.hide()
		else:
			Jugador = "Determinacion"	
			$Deter/EstadoD.show()
	
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
		$PVE.stop()

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
		$Cat/TextureRect.texture = Gato_Gana
		$Draw.play()
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
		var movimientos_validos = []

		for i in range(9):
			if borde[i] == "0":
				borde[i] = "Gato"
				puntaje = Minimax("Determinacion")
				borde[i] = "0"
				mejor_puntaje = max(puntaje, mejor_puntaje)
				if puntaje == 1:
					mejor_movimiento = i
					break
				elif puntaje == 0:
					movimientos_validos.append(i)

		# Prioridad: Bloquear victoria de "Determinacion" o ganar.
		if mejor_movimiento < 0:
			if len(movimientos_validos) > 0:
				mejor_movimiento = movimientos_validos[0]
			elif mejor_puntaje == 1:
				for i in range(9):
					if borde[i] == "0":
						borde[i] = "Gato"
						if JugadorGana("Gato"):
							mejor_movimiento = i
						borde[i] = "0"
						if mejor_movimiento >= 0:
							break
		# Prioridad: Centro, esquinas y luego aleatorio.
		elif borde[4] == "0":
			mejor_movimiento = 4
		#elif borde[2] == "Determinacion" && borde[5] == "Determinacion":
		#	mejor_movimiento = 8
		#elif borde[0] == "0":
		#	mejor_movimiento = 0
		#elif borde[2] == "0":
		#	mejor_movimiento = 2
		#elif borde[6] == "0":
		#	mejor_movimiento = 6
		#elif borde[8] == "0":
		#	mejor_movimiento = 8
		else:
			var esquinas_disponibles = []
			var movimientos_libres = []
			for i in range(9):
				if borde[i] == "0":
					movimientos_libres.append(i)
					if i % 2 == 0 && i != 4:
						esquinas_disponibles.append(i)
			if esquinas_disponibles.size() > 0:
				mejor_movimiento = esquinas_disponibles[randi() % len(esquinas_disponibles)]
			else:
				mejor_movimiento = movimientos_libres[randi() % len(movimientos_libres)]

		return mejor_puntaje
	else:
		mejor_puntaje = INF
		mejor_movimiento = -1
		var movimientos_validos = []

		for i in range(9):
			if borde[i] == "0":
				borde[i] = "Determinacion"
				puntaje = Minimax("Gato")
				borde[i] = "0"
				mejor_puntaje = min(puntaje, mejor_puntaje)
				if puntaje == -1:
					mejor_movimiento = i
					break
				elif puntaje == 0:
					movimientos_validos.append(i)

		# Prioridad: Bloquear victoria de "Gato" o ganar.
		if mejor_movimiento < 0:
			if len(movimientos_validos) > 0:
				mejor_movimiento = movimientos_validos[0]
			elif mejor_puntaje == -1:
				for i in range(9):
					if borde[i] == "0":
						borde[i] = "Determinacion"
						if JugadorGana("Determinacion"):
							mejor_movimiento = i
						borde[i] = "0"
						if mejor_movimiento >= 0:
							break
		elif borde[4] == "0":
			mejor_movimiento = 4
		else:
			var esquinas_disponibles = []
			var movimientos_libres = []
			for i in range(9):
				if borde[i] == "0":
					movimientos_libres.append(i)
					if i % 2 == 0 && i != 4:
						esquinas_disponibles.append(i)
			if esquinas_disponibles:
				mejor_movimiento = esquinas_disponibles[randi() % len(esquinas_disponibles)]
			else:
				mejor_movimiento = movimientos_libres[randi() % len(movimientos_libres)]

		return mejor_puntaje

func MovimientoComputadora() -> void:
	print("9")
	mejor_puntaje = -INF
	mejor_movimiento = -1
	## EXCEPCIONES
	if borde[2] == "Determinacion" && borde[5] == "Determinacion" && solucion == true:
		mejor_movimiento = 8
		solucion = false
	elif borde[8] == "Determinacion" && borde[6] == "Determinacion" && solucion == true:
		mejor_movimiento = 7
		solucion = false 
	elif borde[4] == "Determinacion" && borde[5] == "Determinacion" && solucion == true:
		mejor_movimiento = 3
		solucion = false
	## EXCEPCIONES
	else:
		for i in range(9):
			if borde[i] == "0":
				borde[i] = "Gato"
				puntaje = Minimax("Determinacion")
				borde[i] = "0"
				if puntaje == 1 || puntaje == 0:
					#print("puntaje mayor: ", puntaje)
					mejor_movimiento = i
					break
					#Movimientos_Validos.append(i)
					#if puntaje <= -1:
					#	break
				#print(puntaje, " ", i, " ", mejor_puntaje)
				#print("mejor_movimiento")
	
	if mejor_movimiento >= 0:
		print(mejor_puntaje, " Mejor puntaje")
		print(mejor_movimiento," Mejor movimiento")
	#if mejor_movimiento >= 0:
		borde[mejor_movimiento] = "Gato"
		var path : String
		var fila : int = mejor_movimiento / 3
		path = "Zona/Borde/Fila" + str(fila) + "/Boton" + str(mejor_movimiento)
		get_node(path).texture_normal = Gato
		checar_final()
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
	$PVE.play()


func _on_reiniciar_button_up():
	get_tree().reload_current_scene()
