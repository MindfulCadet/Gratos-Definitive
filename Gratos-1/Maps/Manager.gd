extends Node2D

#TODO: se debe eliminar or completo la instancia anterior
#del mapa (cuando se regrese del combate)
@export var  RPG_character : PackedScene
@export_file("*.tscn") var map 
var camera_pos 

#Crea instancias de los personajes jugables correspondiente al 
#numero de jugadores
func _ready():
	GameControl.n += 1
	$".".name = "Map" + str(GameControl.n)
	map = GameControl.current_map
	print(GameControl.current_map)
	music_select(GameControl.current_map)
	PlayerHandle.index = 0
	
	for i in PlayerHandle.players:
		
		#Crea la instancia del personaje
		var current_player = RPG_character.instantiate()
		current_player.name = str(PlayerHandle.players[i].id)
		
		add_child(current_player)
				
		#Coloca los personajes en la posicion indicada (si sale de un combate
		#toma la ultima posicion guardada)
		for spawn in get_tree().get_nodes_in_group("Spawnpoint"):
			if spawn.name == str(PlayerHandle.index):	
				
				if PlayerHandle.players[i].stats != null:
					current_player.global_position = Manager.player_last_position
				
				else:
					current_player.global_position = spawn.global_position
				#PlayerHandle.players[i].instance = current_player
				

				
		PlayerHandle.index += 1
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func music_select(map):
	match map:
		"res://Maps/DEBE/DEBE.tscn":
			Music.change_track(Music.debe, Music.hub)
		
		"res://Maps/Ecat/ecat.tscn":
			pass

		"res://Maps/Ingenieria/maingenieria.tscn":
			Music.change_track(Music.ingenieria, Music.hub)
			
		"res://Maps/Basico/node_2d.tscn":
			Music.change_track(Music.basico,Music.hub)
			
		"res://Maps/Test_map.tscn":	
			Music.change_track(Music.hub, Music.debe)
			Music.change_track(Music.hub, Music.ingenieria)
			Music.change_track(Music.hub, Music.basico)
