extends CharacterBody2D

const SPEED = 200.0  # 이동 속도
const GRAVITY = 980.0  # 중력 값
const JUMP_VELOCITY = -400.0  # 점프 속도


@onready var anim_sprite = $AnimatedSprite2D  # 애니메이션 노드 가져오기
@onready var projectile_scene = preload("res://scenes/Projectile.tscn")
@onready var attack_point = $Attackpoint # 공격 위치 지정


func _physics_process(delta: float) -> void:
	# 중력 적용
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# 점프 처리
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 좌우 이동 처리
	var direction := Input.get_axis("left", "right")  # "ui_" 제거한 방향 입력 사용
	if direction:
		velocity.x = direction * SPEED
		_update_animation(direction)  # 애니메이션 변경
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)  # 부드럽게 감속
		if is_on_floor():
			anim_sprite.play("idle")  # 정지 상태일 때 idle 애니메이션
		else:
			anim_sprite.play("jump")
	# 공격 처리
	if Input.is_action_just_pressed("attack"):
		anim_sprite.play("charge")
		attack()

	move_and_slide()  # 이동 실행

# ✅ 애니메이션 업데이트 함수
func _update_animation(direction: float):
	if not is_on_floor():
		anim_sprite.play("jump")
	else:
		if direction != 0:
			anim_sprite.play("walk_right" if direction >0 else "walk_left")
			anim_sprite.flip_h = (direction<0)
		else:
			anim_sprite.play("idle")

# ✅ 공격 함수
func attack():
	var projectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.position = attack_point.global_position
	# 방향 설정 (오른쪽이면 1, 왼쪽이면 -1)
	var attack_direction = Vector2.RIGHT if not anim_sprite.flip_h else Vector2.LEFT
	projectile.direction = attack_direction  # 투사체 방향 지정


@onready var hp_bar = $CanvasLayer/HPBar

func _ready() -> void:
	update_hp_ui()
	
func take_damage(amount: int):
	Global.player_hp -= amount
	Global.player_hp = max(Global.player_hp, 0)
	update_hp_ui()
	
	if Global.player_hp <= 0:
		die()
		
func die():
	queue_free()
	
func update_hp_ui():
	hp_bar.value = float(Global.player_hp) / Global.max_player_hp * 100
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):  # 체력 감소 테스트 키 (↓키)
		take_damage(10)
		print("현재 체력:", Global.player_hp)  # 디버깅 출력
