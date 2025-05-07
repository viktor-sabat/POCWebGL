extends Node3D

# Create a new WebSocketPeer instance
var socket = WebSocketPeer.new()

# Called when the node is ready (initialization)
func _ready():
	# Connect to the WebSocket server (replace with your server URL)
	socket.connect_to_url("ws://127.0.0.1:8080/ws/rpm/")

# Called every frame to update the connection state
func _process(delta):
	# Poll the socket to check for any incoming data
	socket.poll()

	# Get the current state of the WebSocket
	var state = socket.get_ready_state()

	# If the connection is open, process any available data
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			# Fetch the raw packet of data
			var raw_packet = socket.get_packet()

			# Decode the byte array into a UTF-8 string
			var json_string = raw_packet.get_string_from_utf8()
			print("Packet as string:", json_string)

			# Parse the string as JSON and check for valid data
			var data = JSON.parse_string(json_string)
			if data != null:
				# Print RPM values
				print("Engine RPM:", data["engine_rpm"])
				print("Electromotor RPM:", data["electromotor_rpm"])

	# If the WebSocket is closing, keep polling to finish the close process
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# If the WebSocket is closed, handle the closure
	elif state == WebSocketPeer.STATE_CLOSED:
		# Fetch the close code and reason for the closure
		var code = socket.get_close_code()
		var reason = socket.get_close_reason()

		# Print the WebSocket closure details
		print("WebSocket closed with code: %d, reason %s. Clean: %s" % [code, reason, code != -1])
		set_process(false) # Stop processing the node (disconnect from WebSocket)
