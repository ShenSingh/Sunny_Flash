extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var player_inattack_zone = false
var health = 100 

var can_take_damage = true


func _physics_process(delta: float) -> void:
	
	deal_with_damage()
	update_health()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if (player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
	else:
		$AnimatedSprite2D.play("idle")
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false


func deal_with_damage():
	if player_inattack_zone and Global.player_current_attack == true:
		
		if can_take_damage == true:	
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health" , health)
			if health <= 0:
				$AnimatedSprite2D.play("death")
				self.queue_free()
		


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true

func update_health():
	
	var healthbar = %EnemyHealth
	
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_enemy_health_timeout() -> void:
	if health < 100:
		health = health + 20 
		
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
