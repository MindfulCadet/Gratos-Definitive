extends Node2D

#El fin se acerca
@onready var menu = $CanvasLayer
var index: int = 0
var selection = []
@export var area :String
#Accede a la carpeta donde se encuentran los enemigos
var files_in_directory = DirAccess.get_files_at("res://Characters/Battle enemies/Scripts/")

#Arreglos que contienen a los enemigos y jugadores
var turn_order = []
var enemies = []
var players = []
var enemy_n = 1
var exp_total = 0 #Almacena la experiencia ganada
var turn_actual = true
var attack_done = false
var finished = false
var lost = false

func _ready():
	Music.change_track(Music.enemigo, Music.hub)
	character_spawn()
	enemy_n = spawn_enemies()
	
	#Crea una mano de selección (para los ataques) por cada enemigo
	for select in enemy_n:
		selection.append(Sprite2D.new())
		selection[select].texture = load("res://Characters/Misc/finger.png")
		selection[select].scale = Vector2(0.09, 0.09)
		selection[select].position = Vector2(enemies[select].position.x - 25, enemies[select].position.y) 

		$".".add_child(selection[select])
		
		selection[select].hide()
		
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
				player = load("res://Characters/PLayable characters/Scenes/Knight.tscn").instantiate()

			"arquero":
				player = load("res://Characters/PLayable characters/Scenes/Archer.tscn").instantiate()
				
			"barbaro":
				player = load("res://Characters/PLayable characters/Scenes/Barbarian.tscn").instantiate()

			"mago":
				player = load("res://Characters/PLayable characters/Scenes/Wizard.tscn").instantiate()

		players.append(player)
		add_child(player)
		players[n].position = $"Players/1".position 
		players[n].play("Idle")
		
		n +=1
	
#TODO: esta funcion deberia ir dentro de global, y depende
#(la aparicion) del area donde se encuentra el jugador
func spawn_enemies():
	var random_enemy
	var enemy
	var random = randi_range(1,3)
	
	for i in random:
		
		random_enemy = files_in_directory[randi() % files_in_directory.size()]
		print(random_enemy)
		enemy = load("res://Characters/Battle enemies/Scripts/" + random_enemy).instantiate()
		enemies.append(enemy)
		add_child(enemies[i])
		match i:
			0:
				enemies[i].position = $"Enemies/0".position 

			1:
				enemies[i].position = $"Enemies/1".position

			2:
				enemies[i].position = $"Enemies/2".position
	
	return random

#Selecciona a un enemigo/aliado (o a todos, si es un ataque multiple)
func enemy_selection(all):
	
	if all:
		for select in selection:
			select.show()
			
		attack_confirmation(players[0],enemies[index], all)
		
	else:
		if !selection.is_empty():
			#Cambia el target del ataque
			if Input.is_action_just_pressed("ui_up"):
				if index > 0:
					index -= 1
					switch_focus(selection[index], selection[index + 1])
			elif Input.is_action_just_pressed("ui_down"):
				if index < enemies.size() - 1:
					index += 1
					switch_focus(selection[index], selection[index - 1])
					
			attack_confirmation(players[0],enemies[index])

#Cambia el focus a otro enemigo seleccionado
func switch_focus(x,y):
	x.show()
	y.hide()
	Music.select.play()
	
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
	#TODO: Si se mata a un enemigo antes de que llegue su turno, sacarlo
	#de ambas listas	
	for enemy in enemies:
		turn_order.append(enemy)
		
	for player in players:
		turn_order.append(player)
	
	turn_order.sort_custom(sort_descending)
	#for entity in turn_order:
		#if entity.enemy == false:
			#print(PlayerHandle.players[multiplayer.get_unique_id()].stats.velocidad)
		#elif entity.enemy == true:
			#print(entity.stats.velocidad)

	
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
	for enemy in len(enemies):	
		if enemy >= len(enemies):
			break
		
		if enemies[enemy].stats.vida <= 0:
			exp_total += enemies[enemy].stats.exp
			enemies.remove_at(enemy)
			selection[enemy].hide()
			selection.remove_at(enemy)
			index = 0
			
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
		
		menu.textbox.dialogue("¡Ganaste %s puntos de experiencia!" % exp_total)
		PlayerHandle.players[multiplayer.get_unique_id()].stats.exp += exp_total
		
		if PlayerHandle.players[multiplayer.get_unique_id()].stats.exp >= GameControl.level_milestones:
			PlayerHandle.players[multiplayer.get_unique_id()].level +=1
			menu.textbox.dialogue("¡Subiste al nivel %s !" % PlayerHandle.players[multiplayer.get_unique_id()].level)
			GameControl.level_milestones *= 2
			
		menu.textbox.show_textbox()
		
	elif finished and !menu.textbox.textbox:
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
	
	
