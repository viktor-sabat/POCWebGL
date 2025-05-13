# POC – Godot WebGL Export with WebSocket Communication

This project showcases a 3D scene built in **Godot Engine**, featuring **WebSocket communication** and export to **HTML5 (WebGL)** for browser-based interaction.

## Tools and Versions

![Godot Engine](https://img.shields.io/badge/Godot-4.4-blue)
![Blender](https://img.shields.io/badge/Blender-4.4-orange)
![WebSocket](https://img.shields.io/badge/WebSocket-GDScript%20Based-purple)
![HTML5 Export](https://img.shields.io/badge/Export-WebGL-green)

## Features

- Exportable to Web (HTML5/WebGL)
- Real-time WebSocket communication for receiving and processing RPM data (`./WebSocketHandler.gd`)

## Clone and Edit Locally

### Clone the Repository

```bash
git clone git@mbst.net.plm.eds.com:BOILERPLATE/godot.git
cd your-godot-project
```

### Open in Godot

1. Launch Godot Engine (version 4.4+)
2. Click **Import**, then select the `project.godot` file inside the cloned folder
3. Open the main scene (e.g., `main.tscn`)
4. Press `F5` or click **Play** to run the scene and ensure everything works as expected

## Running the Web Build Locally

If you want to run the exported WebGL build locally, follow these steps:

1. Go to the `builds/web` folder inside the project directory
2. Open the terminal there
3. Run the following command to serve the WebGL build locally:

```bash
npx local-web-server --https --cors.embedder-policy "required-corp" --cors.opener-policy "same-origin" --directory "."
```

4. Open your browser and go to:

```
https://localhost:8000
```

### Option 2: If the WebGL Build Doesn't Work

If for any reason the available build doesn’t work or if you need to export the project yourself, you can follow the official documentation to export it:

- [Exporting for HTML5](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html)
- [Exporting the Project](https://docs.godotengine.org/en/stable/tutorials/export/exporting_projects.html)

## WebSocket Logic

WebSocket communication is handled in a global singleton (`WebSocketHandler.gd`).

```gdscript
# WebSocketHandler.gd
extends Node

var client := WebSocketClient.new()

func _ready():
    client.connect_to_url("ws://localhost:8080")
    client.connect("data_received", self, "_on_data_received")

func _on_data_received():
    var message = client.get_peer(1).get_packet().get_string_from_utf8()
    # Handle incoming RPM data
```

## Reference

- [Backend Logic Repository](https://mbst.net.plm.eds.com/BOILERPLATE/backend-3d-web-visualization/-/tree/main?ref_type=heads)
