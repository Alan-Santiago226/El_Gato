extends Button

var repdocucir_sonido = false

func _Boton_presionado():
	if not repdocucir_sonido:
		$Gato.play()
		repdocucir_sonido = true

func _Finalizar_Audio():
	repdocucir_sonido = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
