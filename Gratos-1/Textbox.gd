extends CanvasLayer

#Variables listas al momento de llamar al nodo (texto, caja de texto y la animación
#del texto), ademas de una lista que contendra el texto del personaje
@onready var char_text = $"Container Alpha/Container Beta/HBoxContainer/Text"
@onready var symbol = $"Container Alpha/Container Beta/HBoxContainer/Label"
@onready var textbox = $"Container Alpha"
@onready var tween : Tween 
var current_step = Step.STARTED
var text_queue = []

#Pasos del texto
enum Step{
	STARTED,
	READ,
	FINISHED
}


func _ready():
	hide_textbox()


func _process(delta):
	
	#Comprueba el estado del dialogo
	match current_step:
		Step.STARTED:
			pass
		Step.READ:
			if Input.is_action_just_pressed("ui_accept"):
				char_text.visible_ratio = 1
				symbol.text = "V"
				tween.kill()
				
				await get_tree().create_timer(0.7).timeout
				current_step = Step.FINISHED
				
		Step.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				current_step = Step.STARTED
				hide_textbox()
				
			
#Oculta la caja de dialogo en caso de que se haya mostrado todo el dialogo,
#de lo contrario, solo cambia el texto al siguiente en la lista
func hide_textbox():
	
	char_text.text = ""
	symbol.text = ""
	if len(text_queue) != 0:
		show_textbox()
	else:
		textbox.visible = false
		Manager.talking = false


#Anade texto a la lista
func dialogue(add_text):
	text_queue.push_front(add_text)
	
#Muestra el texto en la caja de dialogo
func show_textbox():
	
	char_text.visible_ratio = 0
	tween = create_tween()
	current_step = Step.READ
	char_text.text = text_queue.pop_back()
	textbox.visible = true
	tween.tween_property(char_text,"visible_ratio",1,len(char_text.text)*0.05)
	
	await tween.finished
	symbol.text = "V"
	current_step = Step.FINISHED
	
