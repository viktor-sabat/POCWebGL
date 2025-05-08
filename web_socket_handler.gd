extends Node

# Signal that carries RPM data when a new packet arrives
signal rpm_received(engine_rpm, electromotor_rpm)

# Create a new WebSocket client
var socket = WebSocketPeer.new()

func _ready():
	# Connect to WebSocket server
	socket.connect_to_url("ws://127.0.0.1:8080/ws/rpm/")
	#set_process(true)

func _process(_delta):
	# Poll the WebSocket to process incoming data
	socket.poll()
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		# Loop through all available packets
		while socket.get_available_packet_count():
			var raw_packet = socket.get_packet()
			var json_string = raw_packet.get_string_from_utf8()

			# Parse JSON string into a dictionary
			var data = JSON.parse_string(json_string)

			# If successfully parsed, emit the RPM values
			if data != null and typeof(data) == TYPE_DICTIONARY:
				emit_signal("rpm_received", data["engine_rpm"], data["electromotor_rpm"])
				print("RPM data: ", data["engine_rpm"], ", ", data["electromotor_rpm"])

	elif state == WebSocketPeer.STATE_CLOSING:
		# Keep polling to allow graceful closing
		pass

	elif state == WebSocketPeer.STATE_CLOSED:
		# Log the reason and stop processing
		print("WebSocket closed: ", socket.get_close_reason())
		set_process(false)
