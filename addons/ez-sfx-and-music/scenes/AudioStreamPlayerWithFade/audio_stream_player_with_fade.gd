extends AudioStreamPlayer
class_name AudioStreamPlayerWithFade

var _t: Tween = null

func fade_in(duration: float, target_linear_vol: float = 1.0):
	play()
	if _t != null and _t.is_running():
		_t.kill()
	_t = create_tween()
	_t.tween_method(self.set_vol, db_to_linear(volume_db), target_linear_vol, duration)

func fade_out(duration: float):
	if not playing:
		return
	if _t != null and _t.is_running():
		_t.kill()
	_t = create_tween()
	_t.tween_method(self.set_vol, db_to_linear(volume_db), 0.0, duration)
	_t.tween_callback(self.stop)

func set_vol(linear_vol: float):
	volume_db = linear_to_db(linear_vol)
