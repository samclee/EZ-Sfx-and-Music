extends Node
class_name MusicPlayer

const SOUND_EXTENSIONS = [
	"wav",
	"mp3",
	"ogg"
]

@export var default_fade_duration: float = 0.5
@export var default_target_linear_volume: float = 1.0
@export_dir var music_folder: String
@export var bus_name: String = "Master"
@export var debug_output: bool = false

var _music_sources: Dictionary = {}
var _cur_player_idx = 0


func _ready():
	$AudioStreamPlayer.bus = bus_name
	$AudioStreamPlayer2.bus = bus_name
	_load_music_in_folder(music_folder)


func play(song_name: String, fade_duration: float = default_fade_duration, target_linear_volume: float = default_target_linear_volume) -> void:
	if not song_name in _music_sources:
		if debug_output:
			print("Song \"%s\" not found in music sources" % song_name)
		return
	
	var players: Array = _get_current_and_next_player()
	var old_player = players[0] as AudioStreamPlayerWithFade
	var new_player = players[1] as AudioStreamPlayerWithFade
	
	old_player.fade_out(fade_duration)
	
	new_player.stream = _music_sources[song_name]
	new_player.fade_in(fade_duration, target_linear_volume)
	_cur_player_idx = int(not _cur_player_idx)


func get_current_song_name(fade_duration: float = default_fade_duration) -> String:
	var current_player = _get_current_player() as AudioStreamPlayerWithFade
	if not current_player.playing or current_player.stream.get_length() - current_player.get_playback_position() < fade_duration:
		return ""
	return current_player.stream.resource_path.get_file().get_basename()


func fade_out(fade_duration: float = default_fade_duration) -> void:
	var cur_player = get_child(_cur_player_idx) as AudioStreamPlayerWithFade
	cur_player.fade_out(fade_duration)


func stop() -> void:
	fade_out(0.0)


func _load_music_in_folder(music_folder_path: String) -> void:
	if not DirAccess.dir_exists_absolute(music_folder_path):
		return
	var dir = DirAccess.open(music_folder_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# When building, only .imports stay in the res:// folder, so we use
		# those to check what music used to be there
		if not _is_import_file(file_name):
			file_name = dir.get_next()
			continue
		
		# Strip off the .import to get the original file name
		file_name = file_name.replace(".import", "")
		if not _is_sound_file(file_name):
			file_name = dir.get_next()
			continue
		var song_name = file_name.get_basename()
		
		# Create a pool for the sound if we haven't already
		if not song_name in _music_sources:
			_music_sources[song_name] = ResourceLoader.load(music_folder_path + "/" + file_name)
		elif debug_output:
			print("Song \"%s\" has already been loaded, skipping" % song_name)
		file_name = dir.get_next()


func _is_import_file(file_name: String) -> bool:
	return ".import" in file_name


func _is_sound_file(file_name: String) -> bool:
	return SOUND_EXTENSIONS.has(file_name.get_extension())


func _get_current_and_next_player() -> Array:
	return [
		get_child(_cur_player_idx),
		get_child(int(not _cur_player_idx))
	]


func _get_current_player():
	return get_child(_cur_player_idx)
