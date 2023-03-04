extends Node

@onready var option_button = $Control/OptionButton
@onready var spin_box = $Control/SpinBox
@onready var label_2 = $Control/Label2


func _on_button_pressed():
	if option_button.selected == 2:
		_start_tween_display()
		$MusicPlayer.fade_out(spin_box.value)
	else:
		_start_tween_display()
		$MusicPlayer.play(option_button.get_item_text(option_button.selected),spin_box.value)

func _start_tween_display():
	var t = create_tween()
	t.tween_method(self._set_completion_display, 0, 100, spin_box.value)

func _set_completion_display(percent: int):
	label_2.text = "Transition complete: " + str(percent) + "%"
