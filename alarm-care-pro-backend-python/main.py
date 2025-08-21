import socket
import threading
import time
from datetime import datetime
import sys
import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
from typing import Dict, Optional
import json
import socketio  # <-- Novo

# Add the current directory to Python path for imports
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from utils.handle_bomb_data import handle_bomb_data
from utils.handle_monitor_data import handle_monitor_data
from utils.handle_ventilator_data import handle_ventilator_data
from utils.send_silent_alarm import send_silent_alarm
from utils.send_refresh_alarm import send_refresh_alarm

# Global variables for socket connections
bomb1_socket: Optional[socket.socket] = None
bomb2_socket: Optional[socket.socket] = None
bomb3_socket: Optional[socket.socket] = None
ventilator_socket: Optional[socket.socket] = None
monitor_socket: Optional[socket.socket] = None
frontend_socket: Optional[socket.socket] = None

localhost_ip = '0.0.0.0'

# ===================================
#   CONFIGURAÇÃO DO FASTAPI + SOCKET.IO
# ===================================
sio = socketio.AsyncServer(cors_allowed_origins="*", async_mode="asgi")
app = FastAPI(title="Medical Alarm Backend")
app_sio = socketio.ASGIApp(sio, other_asgi_app=app)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ===================================
#   HANDLERS DE CONEXÕES TCP
# ===================================

def handle_ventilator_connection(client_socket: socket.socket, address):
    """Handle ventilator TCP connection"""
    global ventilator_socket
    print('Nova conexão: Ventilator')
    ventilator_socket = client_socket
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break

            received_message = handle_ventilator_data(data.decode('ascii'))
            if received_message['type'] == 'Ventilator Alarms':
                print(received_message)
                # Enviar atualização para o frontend via Socket.IO
                import asyncio
                asyncio.run(sio.emit("ventilator_message", received_message))

    except ConnectionResetError:
        print('Ventilator desconectado!')
    except Exception as e:
        print(f'Erro na conexão do ventilador: {e}')
    finally:
        client_socket.close()


def handle_monitor_connection(client_socket: socket.socket, address):
    """Handle monitor TCP connection"""
    global monitor_socket
    print('Nova conexão: Monitor')
    monitor_socket = client_socket

    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break

            received_message = handle_monitor_data(data.decode('ascii'))
            # Enviar via Socket.IO para o frontend
            import asyncio
            asyncio.run(sio.emit("monitor_message", received_message))

    except ConnectionResetError:
        print('Monitor desconectado!')
    except Exception as e:
        print(f'Erro na conexão do monitor: {e}')
    finally:
        client_socket.close()


def handle_bomb_connection(client_socket: socket.socket, address, bomb_number: int):
    """Handle bomb TCP connection"""
    global bomb1_socket, bomb2_socket, bomb3_socket
    print(f'Nova conexão: Bomba de infusão {bomb_number}')

    if bomb_number == 1:
        bomb1_socket = client_socket
    elif bomb_number == 2:
        bomb2_socket = client_socket
    elif bomb_number == 3:
        bomb3_socket = client_socket

    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break

            bomb_data = handle_bomb_data(data)
            # Enviar atualização para o frontend via Socket.IO
            import asyncio
            asyncio.run(sio.emit(f"bomb{bomb_number}_message", bomb_data))

    except ConnectionResetError:
        print(f'Bomba de infusão {bomb_number} desconectada!')
    except Exception as e:
        print(f'Erro na conexão da bomba {bomb_number}: {e}')
    finally:
        client_socket.close()


def create_tcp_server(port: int, handler, *args):
    """Create a TCP server"""
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind((localhost_ip, port))
    server_socket.listen(5)

    print(f'TCP Server listening on {localhost_ip}:{port}')

    while True:
        try:
            client_socket, address = server_socket.accept()
            client_thread = threading.Thread(
                target=handler,
                args=(client_socket, address, *args)
            )
            client_thread.daemon = True
            client_thread.start()
        except Exception as e:
            print(f'Erro no servidor TCP porta {port}: {e}')


# ===================================
#   ENDPOINTS DE API PARA BOMBAS
# ===================================

@app.post("/silent/bomb{bomb_number}")
async def silent_bomb(bomb_number: int, serial_number: str):
    global bomb1_socket, bomb2_socket, bomb3_socket
    bomb_socket = None

    if bomb_number == 1:
        bomb_socket = bomb1_socket
    elif bomb_number == 2:
        bomb_socket = bomb2_socket
    elif bomb_number == 3:
        bomb_socket = bomb3_socket

    if bomb_socket:
        try:
            bomb_socket.send(send_silent_alarm(serial_number))
            print(f'Comando para silenciar bomba {bomb_number} enviado!')
            return {"status": "success"}
        except Exception as e:
            print(f'Erro ao silenciar bomba {bomb_number}: {e}')
            return {"status": "error", "message": str(e)}

    return {"status": "error", "message": "Bomb not connected"}


@app.post("/refresh/bomb{bomb_number}")
async def refresh_bomb(bomb_number: int, serial_number: str):
    global bomb1_socket, bomb2_socket, bomb3_socket
    bomb_socket = None

    if bomb_number == 1:
        bomb_socket = bomb1_socket
    elif bomb_number == 2:
        bomb_socket = bomb2_socket
    elif bomb_number == 3:
        bomb_socket = bomb3_socket

    if bomb_socket:
        try:
            bomb_socket.send(send_refresh_alarm(serial_number))
            print(f'Comando para reativar alarmes bomba {bomb_number} enviado!')
            return {"status": "success"}
        except Exception as e:
            print(f'Erro ao reativar alarmes bomba {bomb_number}: {e}')
            return {"status": "error", "message": str(e)}

    return {"status": "error", "message": "Bomb not connected"}


# ===================================
#   START DO SERVIDOR
# ===================================

if __name__ == '__main__':
    # Start TCP servers in separate threads
    tcp_servers = [
        (22001, handle_bomb_connection, 1),  # Bomb 1
        (22002, handle_bomb_connection, 2),  # Bomb 2
        (22003, handle_bomb_connection, 3),  # Bomb 3
        (23000, handle_ventilator_connection),  # Ventilator
        (2222, handle_monitor_connection),     # Monitor
    ]

    for server_config in tcp_servers:
        port = server_config[0]
        handler = server_config[1]
        args = server_config[2:] if len(server_config) > 2 else ()

        server_thread = threading.Thread(
            target=create_tcp_server,
            args=(port, handler, *args)
        )
        server_thread.daemon = True
        server_thread.start()

    print('Server running at 4444! 🚀')
    uvicorn.run(app_sio, host='0.0.0.0', port=4444, log_level="info")
