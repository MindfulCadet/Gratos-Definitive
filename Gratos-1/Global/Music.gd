extends Node

#Soundtrack
@onready var hub = $Hub
@onready var basico = $Basico
@onready var ingenieria = $Ingenieria
@onready var enemigo = $Combate_comun
@onready var victoria = $Victoria
@onready var debe = $Debe
#Efectos de sonido
@onready var select = $SFX/Seleccion
@onready var invalid = $SFX/Invalido
@onready var punch = $SFX/Golpe
@onready var hit = $SFX/Golpeado

#Cambia la cancion
func change_track(to: AudioStreamPlayer2D, from: AudioStreamPlayer2D = null ):
	if from == null:
		to.play()
	else:
		from.stop()
		to.play()
