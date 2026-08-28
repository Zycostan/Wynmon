extends AudioStreamPlayer2D


func _ready() -> void:
	Events.request_sfx.connect(play_sfx)

func play_sfx(instance: AVFXInstance,clip: AudioStream):
	if instance.resource.delay == 0:
		do_play_sfx(instance, clip)
	else:
		await get_tree().create_timer(instance.resource.delay).timeout
		do_play_sfx(instance, clip)

func do_play_sfx(instance: AVFXInstance,clip: AudioStream):
	pitch_scale = randf_range(0.9, 1.1)
	stream = clip
	play()
	finished.connect(instance.finish, CONNECT_ONE_SHOT)
