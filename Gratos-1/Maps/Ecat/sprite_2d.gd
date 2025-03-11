extends Sprite2D

# Velocidad de movimiento del personaje
var speed = 200

func _process(delta):
	var velocity = Vector2()

	# Detectar la entrada del teclado
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1

	# Normalizar el vector de velocidad para evitar movimiento más rápido en diagonal
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	# Mover el Sprite2D actualizando su posición
	position += velocity * delta
