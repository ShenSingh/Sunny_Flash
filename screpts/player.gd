extends CharacterBody2D

const speed = 100
var current_dir = "none"

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 200
var player_alive = true

var attack_ip = false

func _ready() -> void:
	$AnimatedSprite2D.play("front_idle")
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	current_camera()
	update_health()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()

func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
		
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
			
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.y = speed
		velocity.x = 0
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.y = -speed
		velocity.x = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
	
	move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			
			if attack_ip == false:
				anim.play("side_idle")
	
	if dir == "left":
		anim.flip_h = true
		
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	
	if dir == "down":
		anim.flip_h = false
		
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
			
	if dir == "up":
		anim.flip_h = false
		
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")		



func player():
	pass

			
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	
	if body.has_method("enemy"):
		enemy_inattack_range = true
		print("attact")
	


func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	
	if enemy_inattack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$Attack_cooldown.start()
		print("player health :"+ str(health))


func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_pressed("attack"):
		
		Global.player_current_attack = true
		attack_ip = true
		
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$Deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$Deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$Deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$Deal_attack_timer.start()
		
		

func _on_deal_attack_timer_timeout() -> void:
	$Deal_attack_timer.stop()
	Global.player_current_attack = false
	attack_ip = false


func current_camera():
	if Global.current_scene == "world":
		$World_camera.enabled = true
		$Cliffside_camera.enabled = false
	elif Global.current_scene == "cliff_side":
		$World_camera.enabled = false
		$Cliffside_camera.enabled = true



func update_health():
	
	var healthbar = %Healthbar
	
	healthbar.value = health
	
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true


func _on_regin_timer_timeout() -> void:
	if health < 200:
		health = health + 20 
		
		if health > 200:
			health = 200
	if health <= 0:
		health = 0
