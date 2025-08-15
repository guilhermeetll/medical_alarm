import socket
import threading
import time
from datetime import datetime
from flask import Flask
from flask_socketio import SocketIO, emit
import sys
import os

# Add the current directory to Python path for imports
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from utils.handle_bomb_data import handle_bomb_data
from utils.handle_ventilator_data import handle_ventilator_data

# Global variables for socket connections
bomb_socket = None
ventilator_socket = None

localhost_ip = '0.0.0.0'

# Flask and SocketIO setup
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins="*")

def handle_bomb_connection(client_socket, address):
    """Handle bomb TCP connection"""
    global bomb_socket
    print('Bomba de infusão conectada!')
    
    bomb_socket = client_socket
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            # Process bomb data (commented out in original)
            # bomb_data = handle_bomb_data(data)
            # print(bomb_data)
                
    except ConnectionResetError:
        print('Bomba de infusão desconectada!')
    except Exception as e:
        print(f'Erro na conexão da bomba: {e}')
    finally:
        client_socket.close()

def handle_ventilator_connection(client_socket, address):
    """Handle ventilator TCP connection"""
    global ventilator_socket
    print('Ventilador conectado!')
    
    ventilator_socket = client_socket
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            received_message = handle_ventilator_data(data.decode('ascii'))
            # print(received_message)
                
    except ConnectionResetError:
        print('Ventilador desconectado!')
    except Exception as e:
        print(f'Erro na conexão do ventilador: {e}')
    finally:
        client_socket.close()

def create_tcp_server(port, handler):
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
                args=(client_socket, address)
            )
            client_thread.daemon = True
            client_thread.start()
        except Exception as e:
            print(f'Erro no servidor TCP porta {port}: {e}')

# WebSocket event handlers
@socketio.on('connect')
def handle_connect():
    print('Cliente conectado!')

@socketio.on('disconnect')
def handle_disconnect():
    print('Cliente desconectado!')

if __name__ == '__main__':
    # Start TCP servers in separate threads
    tcp_servers = [
        (22000, handle_bomb_connection),     # Bomb
        (23000, handle_ventilator_connection), # Ventilator
    ]
    
    for port, handler in tcp_servers:
        server_thread = threading.Thread(
            target=create_tcp_server,
            args=(port, handler)
        )
        server_thread.daemon = True
        server_thread.start()
    
    print('Running at 3333! 🚀')
    socketio.run(app, host='0.0.0.0', port=3333, debug=False)
