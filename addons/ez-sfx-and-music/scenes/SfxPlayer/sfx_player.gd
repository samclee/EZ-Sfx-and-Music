extends Node
class_name SfxPlayer

const audio_stream_player_pool_scn: PackedScene = preload("res://addons/ez-sfx-and-music/scenes/AudioStreamPlayerPool/audio_stream_player_pool.tscn")
const SOUND_EXTENSIONS = [
	"wav",
	"mp3",
	"ogg"
]


@export_dir var sfx_folder: String
@export var bus_name: String = "Master"
@export var pool_size: int = 6
@export var debug_output: bool = false


func _ready():
	_load_sfx_in_folder(sfx_folder)


func play(sfx_name: String, linear_vol: float = 1.0) -> void:
	if not has_node(sfx_name):
		if debug_output:
			print("Pool for sound effect \"%s\" not found" % sfx_name)
		return
	get_node(sfx_name).play(linear_vol)

# Creates one AudioStreamPlayerPool per .import file found for a sound file
func _load_sfx_in_folder(sfx_folder_path: String) -> void:
	if not DirAccess.dir_exists_absolute(sfx_folder_path):
		if debug_output:
			print("No folder specified, no sfx loaded")
		return
	var dir = DirAccess.open(sfx_folder_path)
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		# When building, only .imports stay in the res:// folder, so we use
		# those to check what sfx used to be there
		if not _is_import_file(file_name):
			file_name = dir.get_next()
			continue
		
		# Strip off the .import to get the original file name
		file_name = file_name.replace(".import", "")
		if not _is_sound_file(file_name):
			file_name = dir.get_next()
			continue
		var pool_name = file_name.get_basename()
		
		# Create a pool for the sound if we haven't already
		if not has_node(pool_name):
			var new_pool: AudioStreamPlayerPool = audio_stream_player_pool_scn.instantiate()
			add_child(new_pool)
			new_pool.inititialize(ResourceLoader.load(sfx_folder_path + "/" + file_name), bus_name, pool_size)
			new_pool.name = pool_name
		elif debug_output:
			print("Pool for sound effect \"%s\" already exists, skipping" % pool_name)
		file_name = dir.get_next()


func _is_import_file(file_name: String) -> bool:
	return ".import" in file_name


func _is_sound_file(file_name: String) -> bool:
	return SOUND_EXTENSIONS.has(file_name.get_extension())
