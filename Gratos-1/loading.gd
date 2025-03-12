extends Control


var listo = load("res://selec_personaje.tscn").instantiate()
func _ready():
	for players in PlayerHandle.players:
		GameControl.players_online +=1
	
	$Transtion._on_play()
	$"AnimationPlayer".play("RESET")
	print(GameControl.players_online)
	
##al finalizar la animación de carga, instancia la pantalla de seleccion de personaje
func _on_animation_player_animation_finished(_anim_name: StringName="RESET"):
	$WorldEnvironment.environment.glow_enabled = false
	$".".visible = false
	print(get_tree())
	get_tree().root.add_child(listo)
	$".".queue_free()
