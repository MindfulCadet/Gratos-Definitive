extends CharacterBody2D

var inside = false


func _ready():
	if $Sprite is AnimatedSprite2D:
		$Sprite.play()
		
#Muestra la caja de dialogo correspodiente al npc (en el caso de que tenga)
func Show_textbox():
	if inside and Input.is_action_just_pressed("ui_cancel") and len(%Textbox.text_queue) == 0 and len(%Node2D.resource.Dialogue) != 0:
		%Textboxsfx.play()
		for index in range(len(%Node2D.resource.Dialogue)):
			%Textbox.dialogue(%Node2D.resource.Dialogue[index])
		%Textbox.show_textbox()
		Manager.talking = true
	
func _process(delta):
	if %Node2D.resource.Friendly:
		Show_textbox()
			
		
func _physics_process(delta):
	move_and_slide()


func _on_event_area_entered(area):
	if %Node2D.resource.Friendly:
		inside = true
	else:
		pass

func _on_event_area_exited(area):
	inside = false 
