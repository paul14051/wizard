extends Node2D

@onready var particles = $CPUParticles2D  # ✅ CPUParticles2D 가져오기

func _ready():
	particles.emitting = true  # ✅ 파티클 강제 실행
	await get_tree().create_timer(particles.lifetime).timeout  # ✅ 파티클 지속 시간 후 제거
	queue_free()  # ✅ 노드 삭제
