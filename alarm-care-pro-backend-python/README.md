# Alarm Care Pro Backend - Python Version

This is a Python refactor of the Node.js Alarm Care Pro Backend system. The system handles medical device communications (infusion pumps, ventilators, and monitors) via TCP sockets and provides a WebSocket interface for frontend communication.

## Project Structure

```
Code_Python/
├── requirements.txt          # Python dependencies
├── server.py                # Main server (equivalent to src/server.ts)
├── simple.py                # Simple server (equivalent to src/simple.ts)
├── server_simple.py         # Basic server (equivalent to server.js)
├── client.py                # TCP client (equivalent to client.js)
├── data_types/              # Type definitions
│   ├── __init__.py
│   ├── monitor.py           # Monitor data types
│   └── ventilator.py        # Ventilator data types
└── utils/                   # Utility functions
    ├── __init__.py
    ├── int_to_bin.py         # Binary conversion utility
    ├── handle_bomb_data.py   # Bomb/pump data handler
    ├── handle_monitor_data.py # Monitor data handler
    ├── handle_ventilator_data.py # Ventilator data handler
    ├── send_silent_alarm.py  # Silent alarm command
    └── send_refresh_alarm.py # Refresh alarm command
```

## Installation

1. Install Python dependencies:

```bash
pip3 install -r requirements.txt
```

## Usage

### Main Server (Full functionality)

Equivalent to `npm run dev` in the Node.js version:

```bash
python3 server.py
```

- Runs on port 4444
- Handles multiple infusion pumps (ports 22001, 22002, 22003)
- Handles ventilator (port 23000)
- Handles monitor (port 2222)
- Provides WebSocket interface for frontend

### Simple Server

Equivalent to `npm run simple` in the Node.js version:

```bash
python3 simple.py
```

- Runs on port 3333
- Handles single infusion pump (port 22000)
- Handles ventilator (port 23000)
- Provides WebSocket interface

### Basic Server

Equivalent to the basic `server.js`:

```bash
python3 server_simple.py
```

- Runs on port 22000
- Basic TCP server for alarm processing
- No WebSocket interface

### Test Client

```bash
python3 client.py
```

- Connects to port 22000
- Sends test message

## Functionality

The Python version provides 1:1 functional equivalence with the Node.js version:

1. **TCP Socket Servers**: Handle connections from medical devices
2. **Data Processing**: Parse and process alarm data from devices
3. **WebSocket Communication**: Real-time communication with frontend
4. **Alarm Management**: Silent and refresh alarm commands
5. **Multi-device Support**: Handle multiple infusion pumps, ventilators, and monitors

## Key Features

- **Infusion Pump Alarms**: Processes 32 different alarm types
- **Ventilator Data**: Handles measurements, settings, and alarms
- **Monitor Data**: Processes vital signs and measurements
- **Real-time Communication**: WebSocket events for frontend integration
- **Device Control**: Send commands to silence or refresh alarms

## Protocol Support

- **TCP**: Raw socket communication with medical devices
- **WebSocket**: Real-time bidirectional communication with frontend
- **Binary Data**: Handles binary alarm data from infusion pumps
- **ASCII Data**: Processes ASCII messages from ventilators and monitors

## Environment

Default server IP: `0.0.0.0` (configurable in code)

## Dependencies

- `flask`: Web framework
- `flask-socketio`: WebSocket support
- `python-socketio`: Socket.IO implementation
- `crcmod`: CRC calculation (for alarm commands)
