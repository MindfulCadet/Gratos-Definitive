extends Node2D

#TODO: se debe eliminar or completo la instancia anterior
#del mapa (cuando se regrese del combate)
@export var  RPG_character : PackedScene
@export_file("*.tscn") var map
var camera_pos 

#Crea instancias de los personajes jugables correspondiente al 
#numero de jugadores
func _ready():
	PlayerHandle.index = 0
	Music.hub.play()
	
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
