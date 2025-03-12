extends Node2D

var activo = false
var clicks = -1
var completados = 0
var contador = 1
var correcta = {"Nivel1": {"1": "6", "2": "Lineal", "3": "6"}, "Nivel2": {"1": "3cm", "2": "sisito", "3": "SanS?"}, "Nivel3": {"1":"verde", "2":"Nao", "3":"Fiora"}}
var revision = {"Nivel1": {"1": false,"2":false,"3":false}, "Nivel2": {"1": false, "2": false, "3": false}, "Nivel3": {"1": false, "2": false, "3": false}}
var preguntas = {"Nivel1": {"1": "Cuantas consonantes hay en la palabra 'palindromo'?", "2": "A que tipo función corresponde la siguiente expresión: y = mx+b?", "3": "Desde el inicio del siglo XXI cuantos años bisiestos ha habido?"}, "Nivel2": {"1":"Mide el universo?", "2": "pollito?", "3": "Papyrus?"}, "Nivel3": {"1": "azul o verde?", "2": "sis?", "3": "mejor campeon de lol?"}}
var pesca = false
var cajas = false
var respuesta = ""
var Trivia = false

var misiones = {
	"1": {"nombre": "Pesca", "descripcion": "Ayuda al aventurero a pescar para alimentar a los gatos", "completada": false},
	"2": {"nombre": "Busqueda", "descripcion": "El profesor X ha perdido sus libros, ayudalo a encontrarlos", "completada": false},
	"3": {"nombre": "Trivia", "descripcion": "Un misterioso aventurero te ofrece una buena recompensa a cambio de resolver una trivia, aunque te da mala espina", "completada": false},
	"4": {"nombre": "Bossfight", "descripcion": "El pejelagarto ha llegado, ayuda a los habitantes a deshacerse de el", "completada": false},
}

#Oculta al boss y al lineedit de las respuestas de la trivia
func _ready():
	$"../respuesta".visible = false

#Revisa constantemente si se entró a las areas de cada mision
#en caso de que se haya entrado y se presione la tecla correspondiente inicia el minijuego
func _process(delta):
	if $"../NPCPesca".inside and Input.is_action_just_pressed("ui_accept") and !pesca:
		print("me ayudas a pescar?")
		pesca = true
		clicks = 0
	if $"../Area2D".area_entered and Input.is_action_just_pressed("ui_cancel") and pesca:
		if clicks == 0:
			pescar(completados)
	if activo and pesca:
		if Input.is_action_just_pressed("ui_accept"):
			clicks += 1
			print(clicks)
	'''if $"../NPCCajas".inside and Input.is_action_just_pressed("ui_cancel") and misiones["1"]["completada"] == true:
		if misiones["2"]["completada"] != true:
			cajas = true
	if $"../Caja".area_entered and Input.is_action_just_pressed("ui_accept") and cajas and misiones["1"]["completada"] == true:
		print("encontraste la caja correcta")
		busqueda()
	if $"../NPCTrivia".inside and Input.is_action_just_pressed("ui_cancel") and misiones["2"]["completada"] == true:
		$"../respuesta".visible = true
		Trivia = true
		trivia()'''


func pescar(completada):
	if completados == 0:
		print("El jugador esta pescando")
		print("Preparate, para poder pescar la comida hay que presionar multiples veces la tecla enter, lo mas rapido posible")
		$"../Timer".wait_time = 5.0
		$"../Timer".one_shot = true
		$"../Timer".start()
		activo = true
	elif completados > 0 and completados < 3:
		print("Round: ", completados+1)
		$"../Timer".wait_time = 5.0
		$"../Timer".one_shot = true
		$"../Timer".start()
		activo = true
	else:
		print("Felicidades, pescaste suficiente comida para los gatos, ahora ve con el aventurero para entregarla")
		misiones["1"]["completada"] = true
	

func busqueda():
	misiones["2"]["completada"] = true
	print(misiones)
	cajas = false


#solo falta comprobar que funcione igual al integrarlo
func trivia():
	if revision["Nivel3"]["3"] == true:
		misiones["3"]["completada"] = true
		Trivia = false
		print(misiones)
	else:
		var pregunta = preguntas["Nivel"+str(contador)][str(completados)]
		var bien
	
		if Input.is_action_just_pressed("ui_accept") and $respuesta.visible == true:
			respuesta = $"../respuesta".text
			print(respuesta)
			bien = responder(preguntas, respuesta, correcta["Nivel"+str(contador)][str(completados)])
		
		if bien == true:
			revision["Nivel"+str(contador)][str(completados)] = true
			completados += 1
			bien = false
			print(revision)
			print(preguntas)
		if completados > 3 and contador < 3:
			completados = 1
			contador += 1
		

func responder(pregunta, respuesta, correcta):
	if respuesta == correcta:
		print("correcto")
		#marcar la clave de la respuesta como correcta
		return true
	else:
		print("Incorrecto")


'''
func bossfight():
	var completadas = 0
	for i in misiones:
		if misiones[i]["completada"] == true:
			completadas += 1
	if completadas == 3:
		$"../miniBoss".visible = true
		print("puedes luchar contra el boss")
		#permitir el acceso a la bossfight y mandar a la escena de combate
'''
#Cuando se acaba el tiempo se revisa la cantidad de clicks
#y se dice si se ganó o perdió
func _on_timer_timeout():
	activo = false
	#Nivel 1: Facil
	if clicks >= 30 and completados == 0:
		print("ganaste")
		completados += 1
		clicks = 0
	elif clicks < 30 and $"../Timer".is_stopped() == true:
		print("perdiste")
		clicks = 0
	#Nivel 2: Medio
	elif clicks >= 35 and completados == 1:
		print("ganaste")
		completados += 1
		clicks = 0
	elif clicks < 35 and completados == 1:
		print("perdiste")
		clicks = 0
	#Nivel 3: Dificil
	elif clicks >= 36 and completados == 2:
		print("ganaste el minijuego completo")
		completados += 1
		pescar(completados)
	elif clicks < 36 and completados == 2:
		print("perdiste")
		clicks = 0
