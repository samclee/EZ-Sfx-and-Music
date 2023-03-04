extends Node
class_name AudioStreamPlayerPool


var _stream: AudioStream = null
var _bus: String
var _current_player_idx: int = 0


func inititialize(stream: AudioStream, bus: String, pool_size: int):
	_stream = stream
	_bus = bus
	for _i in range(pool_size):
		_add_new_player()


func play(linear_vol: float) -> void:
	_current_player_idx = (_current_player_idx + 1) % get_child_count()
	var current_player = get_child(_current_player_idx) as AudioStreamPlayer
	current_player.volume_db = linear_to_db(linear_vol)
	current_player.play()


func _add_new_player() -> void:
	var new_player = AudioStreamPlayer.new()
	new_player.stream = _stream
	new_player.bus = _bus
	add_child(new_player)
