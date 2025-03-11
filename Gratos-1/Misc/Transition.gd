extends Area2D

@export_file("*.tscn") var to
@export var positionx : int
@export var positiony : int

func battle_scene(map):
	match map:
		"res://Maps/DEBE/DEBE.tscn":
			Manager.arena = "res://Combat/Combat maps/Debe_combate.tscn"
		
		"res://Maps/Ecat/ecat.tscn":
			Manager.arena = "res://Combat/Combat maps/Decanato_combate.tscn"
			
		"res://Maps/Ingenieria/maingenieria.tscn":
			Manager.arena = "res://Combat/Combat maps/Ingenieria_combate.tscn"
			
		"res://Maps/Basico/node_2d.tscn":	
			Manager.arena = "res://Combat/Combat maps/Basico_combate.tscn"

func _on_area_entered(area):
	GameControl.current_map = to
	battle_scene(to)
	Manager.player_last_position = Vector2( positionx, positiony)
	Manager.change_map(get_parent().get_tree().root, to)
	
