extends Control

@onready var animacion = $AnimationPlayer
@onready var texto = $Label
var personajes = PlayerHandle.characters
var tamaño = PlayerHandle.players.size()
var posibilidades = [["caballero", "barbaro"], ["caballero", "arquero"], ["caballero", "mago"], ["barbaro", "arquero"], ["barbaro", "mago"], ["arquero", "mago"]]
var contador = 0
var nro = 0

#Si se presiona el personaje se oculta el texto previo
#e inicia la animación para confirmar la selección
func _on_personaje_1_pressed():
	texto.hide()
	$Knight.visible = true
	$Knight.play("default")
	#animacion.play("selection1")
	$Si.visible = true
	$No.visible = true
	$Stats.visible = true
	nro = 1
	
func _on_personaje_2_pressed():
	texto.hide()
	$Barbarian.visible = true
	$Barbarian.play("default")
	#animacion.play("selection2")
	$Stats.visible = true
	$Si.visible = true
	$No.visible = true
	nro = 2

func _on_personaje_3_pressed():
	texto.hide()
	$Archer.visible = true
	$Archer.play("default")
	#animacion.play("selection3")
	$Stats.visible = true
	$Si.visible = true
	$No.visible = true
	nro = 3
	
func _on_personaje_4_pressed():
	texto.hide()
	$Wizard.visible = true
	$Wizard.play("default")
	#animacion.play("selection4")
	$Stats.visible = true
	$Si.visible = true
	$No.visible = true
	nro = 4
#Detiene la animación de confirmación y llama a la funcion de deshabilitar
#los personajes seleccionados
func _on_si_pressed():
	
	if nro == 1:
		#for i in PlayerHandle.players:
			#if get_tree().get_network_unique_id() == PlayerHandle.players[i].id:
				#PlayerHandle.players[i].character =

		animacion.stop()
		PlayerHandle.players[multiplayer.get_unique_id()].character = "caballero"		
		deshabilitar.rpc(1)


		#print(PlayerHandle.players[multiplayer.get_unique_id()])
				
	elif nro == 2:
		animacion.stop()
		PlayerHandle.players[multiplayer.get_unique_id()].character = "barbaro"
		deshabilitar.rpc(2)

	#podira usar match tambien
	elif nro == 3:
		animacion.stop()
		PlayerHandle.players[multiplayer.get_unique_id()].character = "arquero"
		deshabilitar.rpc(3)


	elif nro == 4:
		animacion.stop()
		PlayerHandle.players[multiplayer.get_unique_id()].character = "mago"
		deshabilitar.rpc(4)

		

#Detiene la animación de confirmación para poder seleccionar otro personaje
func _on_no_pressed():
	animacion.stop()
	$Stats.visible = false
	if nro == 1:
		$Knight.stop()
		$Knight.visible = false
	elif nro == 2:
		$Barbarian.stop()
		$Barbarian.visible = false
	elif nro == 3:
		$Archer.stop()
		$Archer.visible = false
	elif nro == 4:
		$Wizard.stop()
		$Wizard.visible = false
	
#COLOCAR QUE SE AÑADAN LOS PERSONAJES EN BASE A LA LISTA
#A VER SI ASI LOS AÑADE BIEN

#deshabilita los personajes seleccionados y
#añade a una lista los personajes seleccionados
@rpc("any_peer", "call_local")
func deshabilitar(nro):
	if nro == 1:
		$Personaje1.disabled = true
		personajes.append("caballero")
		revision()
	elif nro == 2:
		$Personaje2.disabled = true
		personajes.append("barbaro")
		revision()
	elif nro == 3:
		$Personaje3.disabled = true
		personajes.append("arquero")
		revision()
	elif nro == 4:
		$Personaje4.disabled = true
		personajes.append("mago")
		revision()
		

#comprueba el tamaño del diccionario para saber la cantidad de jugadores
#en caso de ser uno, pasa al juego, en caso de ser dos
#revisa la lista para verificar que ambos jugadores hayan escogido personaje
#si se cumple, avanza y muestra el juego
func revision():
	var cantidad = personajes.size()
	if cantidad == 1:
		var game = load("res://Maps/Basico/node_2d.tscn").instantiate()
		get_tree().root.add_child(game)
		$".".visible = false
	'''else:
		if cantidad >= 2 :
			var game = load("res://Maps/Test_map2.tscn").instantiate()
			get_tree().root.add_child(game)
			$".".visible = false
'''
	



func _on_ready() -> void:
	$Transtion._on_play()
	$cleaner.start()
	
#
#
#
func _on_cleaner_timeout() -> void:
	$Transtion.visible = false
	
