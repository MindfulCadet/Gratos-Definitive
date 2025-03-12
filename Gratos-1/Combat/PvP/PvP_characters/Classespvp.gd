extends AnimatedSprite2D

#Variables que se mostraran en el inspector del nodo correspondiente
#al personaje
@export_category("Player settings")
@export_enum("caballero","mago", "arquero","barbaro") var clase = "mago"
@export var nivel:int = 1
@export var attacks : Array[Skill] 
@export var enemy = false
@export var new = 1
#Barra de vida y magia para el combate
@onready var life = $Life
@onready var magic = $Magic
func _ready() -> void:
	show_life_magic()
	play("Idle")

func _process(delta: float):
	if Manager.battle == true:
		update_stats()
		
func _on_animation_finished():
	if animation == "Attack":
		play("Idle")
		await get_tree().create_timer(1).timeout
		get_parent().turn_actual = true
		
	elif animation == "Hurt":
		play("Idle")
		await get_tree().create_timer(1).timeout
		get_parent().turn_actual = true
		
	elif animation == "Death":
		pass

func show_life_magic():
	if Manager.battle == true:
		#Llena la barra de magia y vida, acorde a la cantidad del momento
		life.max_value = PlayerHandle.players[multiplayer.get_unique_id()].stats.max_vida
		life.value = PlayerHandle.players[multiplayer.get_unique_id()].stats.vida
		magic.max_value = PlayerHandle.players[multiplayer.get_unique_id()].stats.max_magia
		magic.value = PlayerHandle.players[multiplayer.get_unique_id()].stats.magia
		
		#Muestra ambas barras (en combate)
		life.show()
		magic.show()
		
#Actualiza los stats del jugador
func update_stats():
	var current_life = PlayerHandle.players[multiplayer.get_unique_id()].stats.vida
	var current_magic = PlayerHandle.players[multiplayer.get_unique_id()].stats.magia
	
	if life.value != current_life:
		life.value = current_life
		
		if life.value > 0:
			play("Hurt")
			Music.hit.play()
		
		elif life.value <= 0:
			play("Death")
			Music.hit.play()
		
	
	if magic.value != current_magic:
		magic.value = current_magic
		
