extends Node

var player_hp: int = 100 # ✅ 플레이어 체력
var max_player_hp: int = 100  # ✅ 플레이어 최대 체력

var enemy_hp: Dictionary = {}  # ✅ 적 체력 관리 (id → HP)

# ✅ 적의 체력을 저장하는 함수
func set_enemy_hp(enemy_id: int, hp: int):
	enemy_hp[enemy_id] = hp

# ✅ 적의 체력을 가져오는 함수
func get_enemy_hp(enemy_id: int) -> int:
	return enemy_hp.get(enemy_id, 0)
