extends Panel

@export var label: TypeoutLabel
@export var message_queue: Array[String] = []

var current_message: String = ""
var current_instance: AVFXInstance

func _ready() -> void:
	Events.on_avfx_messages.connect(queue_messages)

func _input(event: InputEvent) -> void:
	if current_message != "" and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		dismiss_message()
		

func queue_messages(instance: AVFXInstance, messages: Array[String]):
	for message in messages:
		message_queue.append(message)
	current_instance = instance
	show_message(message_queue.pop_front())

func show_message(message):
	current_message = message
	label.populate(message)

func dismiss_message():
	current_message = ""
	if message_queue.size() == 0:
		current_instance.finish()
		current_instance = null
	else:
		show_message(message_queue.pop_front())
