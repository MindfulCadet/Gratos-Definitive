extends Node

@export var  RPG_character : PackedScene
var peer
var port = 9999
var host_id = 0
var carga = load("res://loading.tscn").instantiate()

# Llama a una funcion segun el estado del jugador
func _ready():
	$Control/Knight.play("default")
	$Control/Barbarian.play("default")
	$Control/Archer.play("default")
	$Control/Wizard.play("default")
	$BGcreditos.visible = false
	$Cerrar.visible = false
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	$Transtion2._on_play()
	$cleaner2.start()
	
func peer_connected(_id):
	print("Player connected " + %Player_name.text)
	
func peer_disconnected(id):
	#for i in PlayerHandle.player:
		#if id == PlayerHandle.player[i].id:
			#PlayerHandle.player[i].intance.free()
	print("Player disconnected " + str(id))
	
#LLama cuando un jugador se conecta al servidor
func connected_to_server():
	print("Connected to server! " + %Player_name.text)
	player_info.rpc_id(1,%Player_name.text,multiplayer.get_unique_id())

	
	
func connection_failed():
	print("Couldn't connect")
	

#Todos los jugadores llaman a la funcion (guarda informacion de los mismos)
@rpc("any_peer")
func player_info(nameP,id):
	if !PlayerHandle.players.has(id):
		PlayerHandle.players[id] = {
			"name" : nameP,
			"id" : id,
			"character" : null,
			"skills" : null,
			"level":1,
			"stats":null
		}


	if multiplayer.is_server():
		for i in PlayerHandle.players:
			player_info.rpc(PlayerHandle.players[i].name, i)
			
#Inicia el juego al presionar el boton de iniciar 
@rpc("any_peer", "call_local")
func StartGame():
	$Transtion.visible = true
	$Transtion._on_play()
	$Control/AnimationPlayer.play(("hide"))
	$cleaner.start()

	

func _on_play_button_down():
	print("play<<<<<<<<<<<")
	peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	multiplayer.set_multiplayer_peer(peer)
	host_id = multiplayer.get_unique_id()
	
	player_info(%Player_name.text, host_id)


func _on_ip_text_submitted(_new_string: String):
	_on_join_pressed()


func _on_join_pressed():
	print("join><<<<<<<<<<<")
	peer = ENetMultiplayerPeer.new()
	peer.create_client(%IP_owner.text, port)
	multiplayer.set_multiplayer_peer(peer)
	
#Al presionar el boton de test, inicia el juego	
@rpc("any_peer", "call_local")
func _on_button_pressed():
	StartGame.rpc()
	_on_play_button_down()

#Al presionar un sprite, iniica el juego
@rpc("any_peer", "call_local")
func _on_sprite_button_pressed():
	_on_button_pressed()


func _on_cleaner_timeout() -> void:
	$Control.visible = false
	get_tree().root.add_child(carga)
	carga.visible = true


func _on_cleaner_2_timeout() -> void:
	$Transtion2.visible = false


func _on_credits_pressed():
	$BGcreditos.visible = true
	$Cerrar.visible = true


func _on_close_pressed() -> void:
	$BGcreditos.visible = false
	$Cerrar.visible = false
