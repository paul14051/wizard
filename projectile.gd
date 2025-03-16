extends Area2D

@export var damage: int = 10  # ✅ 공격력
@export var speed: float = 500.0  # 투사체 속도
@export var explosion_scene: PackedScene
var direction: Vector2 = Vector2.ZERO  # 이동 방향


func _physics_process(delta):
	# 투사체를 지정된 방향으로 이동
	position += direction * speed * delta

# 충돌하면 사라지도록 설정
func _on_body_entered(body):
	if body.is_in_group("enemy"):  # 적과 충돌했을 때
		body.take_damage(damage)  # 적에게 피해를 줌 
		_explode() #폭발 효과 후 삭제
		queue_free()  # 투사체 제거
	elif body.is_in_group("wall"):
		_explode()
		queue_free()
		

func _explode():
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		get_parent().add_child(explosion)
		explosion.global_position = global_position
		queue_free()	

# 일정 시간이 지나면 자동으로 삭제
func _ready():
	await get_tree().create_timer(2.0).timeout  # 2초 후 삭제
	queue_free()
