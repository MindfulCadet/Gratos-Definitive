extends Node2D

#El fin se acerca
@onready var menu = $CanvasLayer
var index: int = 0
var selection = []
@export var area :String
#Accede a la carpeta donde se encuentran los enemigos
var files_in_directory  

#Arreglos que contienen a los enemigos y jugadores
var turn_order = []
var enemies = []
var players = []
var enemy_n = 1

var turn_actual = true
var attack_done = false
var finished = false
var lost = false

func _ready():

	Music.enemigo.play()

	character_spawn()
		
	order()
	
#Permite seleccionar a uno de los oponentes para atacar
#en el caso de que el ataque no sea multiple
func _process(delta):
	if !finished and !lost:
		turn()
		check_status()
		
	battle_end()

		
func character_spawn():
	var player
	var n = 0
	#Verifica la clase del jugador/jugadores, e instancia la correspondiente
	for p in PlayerHandle.players:
		match PlayerHandle.players[p].character:
			"caballero":
				player = load("res://Combat/PvP/PvP_characters/Knight.tscn").instantiate()

			"arquero":
				player = load("res://Combat/PvP/PvP_characters/Archer.tscn").instantiate()
				
			"barbaro":
				player = load("res://Combat/PvP/PvP_characters/Barbarian.tscn").instantiate()

			"mago":
				player = load("res://Combat/PvP/PvP_characters/Wizard.tscn").instantiate()

		players.append(player)
		add_child(player)
		
		if n == 0:
			players[n].position = $Player1.position 
			
		else:
			players[n].position = $Player2.position
			players[n].flip_h = true
		
		players[n].play("Idle")
		
		n +=1
	
#Confirma el ataque a enemigo seleccionado
func attack_confirmation(attacker, target, global = false):
	
	if attacker.enemy:
		var skill = attacker.choose_random_skill()
		attacker.play("Attack")
		Music.punch.play()
		DamageModifiers.dmg_calculator(attacker.stats, PlayerHandle.players[multiplayer.get_unique_id()].stats, skill, attacker.stats.nivel)
		target.update_stats()
		
	else:
		if Input.is_action_just_pressed("ui_text_submit") and !attack_done:
			attack_done = true
			if global:
				for enemy in enemies:
					players[0].play("Attack")
					Music.punch.play()
					DamageModifiers.dmg_calculator( PlayerHandle.players[multiplayer.get_unique_id()].stats,enemy.stats,menu.current_skill, players[0].nivel, true)
					enemy.update_stats()
					
				
			else:
				#Calculador de ataque y update a los stats
				players[0].play("Attack")
				Music.punch.play()
				DamageModifiers.dmg_calculator( PlayerHandle.players[multiplayer.get_unique_id()].stats,target.stats,menu.current_skill, players[0].nivel)
				target.update_stats()
				#selection[index].hide()
							
			
			
					
			DamageModifiers.global_dropped = false
			menu.hide()
			turn_order.pop_front()
			for select in selection:
				select.hide()
			
	
		
#Establece el orden de turnos (Añade enemigos y jugadores)
func order():
		
	for player in players:
		turn_order.append(player)
	
	turn_order.sort_custom(sort_descending)

#Funcion para usar como Callable y arreglar el orden de turnos
#(TODO: limpiar la funcion, para que se vea mejor; esto requiere
#los stats los tenga instanciados el propio personaje)
func sort_descending(a, b):
	
	if a.enemy == false:
		if PlayerHandle.players[multiplayer.get_unique_id()].stats.velocidad > b.stats.velocidad:
			return true
		return false
		
	elif b.enemy == false:
		if  a.stats.velocidad > PlayerHandle.players[multiplayer.get_unique_id()].stats.velocidad:
			return true
		return false
		
	else:
		if a.stats.velocidad > b.stats.velocidad:
			return true
		return false
		
#Script para determinar quien es el siguiente en atacar
func turn():
	if !turn_order.is_empty():
		
		if !turn_order[0].enemy and menu.menu.name == menu.current_menu and turn_actual:
			print("hey")
			attack_done = false
			turn_actual = false
			menu.show()
			menu.menu.show()
		
		elif turn_order[0].enemy and !menu.visible and turn_actual:
			print("hey2")
			turn_actual = false
			attack_confirmation(turn_order[0],players[0])		
			turn_order.pop_front()
			
	
	else:
		order()
		menu.current_menu = menu.menu.name
			
	
#Comprueba si los enemigos fueron derrotados, o si el jugador gano/murio
func check_status():
	for turn in len(turn_order):
		
		if turn >= len(turn_order):
			break	
			
		if turn_order[turn].enemy and turn_order[turn].stats.vida <= 0:
			turn_order.pop_at(turn)
			
	if players[0].life.value <= 0:
		game_over()
		

func battle_end():
	if enemies.is_empty() and !finished:
		Music.change_track(Music.victoria,Music.enemigo)
		finished = true
		menu.container.hide()
		menu.show()
		menu.textbox.show()
		
		menu.textbox.dialogue("¡Ganaste!")
		
		if PlayerHandle.players[multiplayer.get_unique_id()].stats.exp >= GameControl.level_milestones:
			PlayerHandle.players[multiplayer.get_unique_id()].level +=1
			menu.textbox.dialogue("¡Subiste al nivel %s !" % PlayerHandle.players[multiplayer.get_unique_id()].level)
			GameControl.level_milestones *= 2
			
		menu.textbox.show_textbox()
		
	elif finished and !menu.textbox.textbox:
		Music.victoria.stop()
		Manager.change_to(get_parent().get_tree().root, "Combate")
		
func game_over():
	lost = true
	Music.enemigo.stop()
	menu.container.hide()
	menu.show()
	menu.textbox.show()
	
	menu.textbox.dialogue("Oh no...")
	menu.textbox.show_textbox()
	
	if !menu.textbox.textbox:
		pass
	
	
