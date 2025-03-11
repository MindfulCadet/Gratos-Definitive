extends Node2D

@export_file("*.tscn") var arena 
var talking = false
var reaady = false
var battle= false
var encounter : int = 30:
	set(value):
		encounter = value
		
var enemy_cache : Dictionary = {}

var enemy_appearence = {
	"Basico" : ["000","001","002"],
	"Ingenieria" : ["003","004","005"],
	"Debe" : ["006","007","008"],
	"Decanato" : ["009","010","011"],
}
		
var player_last_position : Vector2 = Vector2(0,0)

func _ready():
	randomize()
	encounter = randi_range(25,50)
	
func change_to(tree, type: String):
	if GameControl.current_map == "res://Maps/Test_map.tscn":
		return 0
	
	if type == ("Map" + str(GameControl.n)):
		tree.get_node(type).queue_free()
		#current_tree.change_to_scene(arena)
		var battle_scene = load(arena).instantiate()
		battle = true
		tree.add_child(battle_scene)
		
	elif type == "Combate":
		tree.get_node(type).queue_free()
		#current_tree.change_to_scene(arena)
		var battle_scene = load(GameControl.current_map).instantiate()
		battle = false
		tree.add_child(battle_scene)


func change_map(from, to):
	from.get_node("Map" + str(GameControl.n)).queue_free()
	
	var new_map = load(to).instantiate()
	from.add_child(new_map)
	
func save_data(player):
	player_last_position = player.position
	
