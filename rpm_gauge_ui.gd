extends Control

# References to needles and sliders
@onready var needle_engine = $EngineNeedle
@onready var needle_electro = $ElectromotorNeedle
@onready var slider_engine = $EngineRadialSlider
@onready var slider_electro = $ElectromotorRadialSlider

# Engine RPM and angle range
const ENGINE_RPM_MIN := 0
const ENGINE_RPM_MAX := 8000
const ENGINE_ANGLE_MIN := 0
const ENGINE_ANGLE_MAX := 114.2

# Electromotor RPM and angle range
const ELECTRO_RPM_MIN := 0
const ELECTRO_RPM_MAX := 10000
const ELECTRO_ANGLE_MIN := 0
const ELECTRO_ANGLE_MAX := -143.0

# Current RPM values (updated live)
var current_engine_rpm = 0.0
var current_electro_rpm = 0.0

func _ready():
	# Connect to RPM signal from WebSocket handler
	var websocket_handler = get_node("/root/Main/WebSocketHandler")
	if websocket_handler:
		websocket_handler.rpm_received.connect(_on_rpm_received)

# Called when RPM data is received
func _on_rpm_received(engine_rpm: float, electro_rpm: float):
	current_engine_rpm = engine_rpm
	current_electro_rpm = electro_rpm
	update_needles()
	update_sliders()

# Rotate needles based on RPM values
func update_needles():
	var engine_angle = map_range_clamped(current_engine_rpm, ENGINE_RPM_MIN, ENGINE_RPM_MAX, ENGINE_ANGLE_MIN, ENGINE_ANGLE_MAX)
	var electro_angle = map_range_clamped(current_electro_rpm, ELECTRO_RPM_MIN, ELECTRO_RPM_MAX, ELECTRO_ANGLE_MIN, ELECTRO_ANGLE_MAX)
	needle_engine.rotation_degrees = engine_angle
	needle_electro.rotation_degrees = electro_angle

# Update progress bars (radial sliders)
func update_sliders():
	slider_engine.value = current_engine_rpm
	slider_electro.value = current_electro_rpm

# Clamp and map RPM to angle range
func map_range_clamped(value: float, in_min: float, in_max: float, out_min: float, out_max: float) -> float:
	var clamped = clamp(value, in_min, in_max)
	var normalized = (clamped - in_min) / (in_max - in_min)
	return lerp(out_min, out_max, normalized)
