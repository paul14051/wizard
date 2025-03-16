extends CharacterBody2D

@export var enemy_id: int  # ✅ 적 ID (각 적마다 고유하게 설정)
@export var max_hp: int = 50  # ✅ 적 최대 체력

@onready var hp_bar = $HPBar  # ✅ 적 HP 바 연결

func _ready():
	Global.set_enemy_hp(enemy_id, max_hp)  # ✅ 전역 변수에 적 체력 저장
	update_hp_ui()

func take_damage(amount: int):
	var current_hp = Global.get_enemy_hp(enemy_id) - amount
	Global.set_enemy_hp(enemy_id, max(current_hp, 0))  # ✅ 체력이 0 이하로 내려가지 않도록 제한
	update_hp_ui()

	if current_hp <= 0:
		die()

func die():
	queue_free()  # ✅ 적 사망 처리 (추후 경험치 추가 가능)

func update_hp_ui():
	var current_hp = Global.get_enemy_hp(enemy_id)
	hp_bar.value = float(current_hp) / max_hp * 100  # ✅ HP 바 업데이트
