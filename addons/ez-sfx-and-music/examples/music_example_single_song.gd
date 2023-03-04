extends Node

@onready var button = $Control/Button
@onready var button_2 = $Control/Button2
@onready var spin_box = $Control/SpinBox
@onready var label_3 = $Control/Label3


func _on_button_pressed():
	button.disabled = true
	button_2.disabled = false
	_start_tween_display()
	$MusicPlayer.play("Dungeon Theme", spin_box.value)


func _on_button_2_pressed():
	button_2.disabled = true
	button.disabled = false
	_start_tween_display()
	$MusicPlayer.fade_out(spin_box.value)

func _start_tween_display():
	var t = create_tween()
	t.tween_method(self._set_completion_display, 0, 100, spin_box.value)

func _set_completion_display(percent: int):
	label_3.text = "Transition complete: " + str(percent) + "%"
