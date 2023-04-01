extends KinematicBody2D

var velocity = Vector2()
const GRAVITY = 40
var speed = 50
export var direction = -1
export var detects_cliffs = true

func _ready():
	$AnimatedSprite.flip_h = direction > 0
	$FloorDetector.position.x = $CollisionShape2D.shape.get_extents().x * direction
	$FloorDetector.enabled = detects_cliffs
	
func _physics_process(delta):

	velocity.y += GRAVITY
	velocity.x = speed * direction
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_wall() or (not $FloorDetector.is_colliding() and detects_cliffs and is_on_floor()):
		direction *= -1
		$AnimatedSprite.flip_h = direction > 0
		$FloorDetector.position.x = $CollisionShape2D.shape.get_extents().x * direction
 


func _on_Hurtbox_body_entered(body):
	$AnimatedSprite.play("dead")
	speed = 0
	set_collision_layer_bit(2, false)
	set_collision_mask_bit(0, false)
	$Hurtbox.set_collision_mask_bit(0, false)
	body.bounce()
	
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
	


