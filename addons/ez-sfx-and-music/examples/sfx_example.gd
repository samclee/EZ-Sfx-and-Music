extends Node

@onready var volume_label = $MarginContainer/HBoxContainer/VBoxContainer/Label
@onready var volume_slider = $MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/VSlider


func _on_v_slider_value_changed(value):
	volume_label.text = "Linear volume: " + str(volume_slider.value)


func _on_button_pressed():
	$SfxPlayer.play("sfx_exp_long1", volume_slider.value)


func _on_button_2_pressed():
	$SfxPlayer.play("sfx_sound_depressurizing", volume_slider.value)


func _on_button_3_pressed():
	$SfxPlayer.play("sfx_sound_shutdown2", volume_slider.value)
