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
from utils.handle_monitor_data import handle_monitor_data
from utils.handle_ventilator_data import handle_ventilator_data
from utils.send_silent_alarm import send_silent_alarm
from utils.send_refresh_alarm import send_refresh_alarm

# Global variables for socket connections
bomb1_socket = None
bomb2_socket = None
bomb3_socket = None
ventilator_socket = None
monitor_socket = None
frontend_socket = None

localhost_ip = '0.0.0.0'

# Flask and SocketIO setup
app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app, cors_allowed_origins="*")

def handle_ventilator_connection(client_socket, address):
    """Handle ventilator TCP connection"""
    global ventilator_socket, frontend_socket
    print('Nova conexão: Ventilador')
    
    ventilator_socket = client_socket
    
    if frontend_socket:
        socketio.emit('reconnect', namespace='/')
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            received_message = handle_ventilator_data(data.decode('ascii'))
            if received_message['type'] == 'Ventilator Alarms':
                print(received_message)
            
            if frontend_socket:
                socketio.emit('ventilator_message', received_message, namespace='/')
                
    except ConnectionResetError:
        print('Ventilador desconectado!')
    except Exception as e:
        print(f'Erro na conexão do ventilador: {e}')
    finally:
        client_socket.close()

def handle_monitor_connection(client_socket, address):
    """Handle monitor TCP connection"""
    global monitor_socket, frontend_socket
    print('Nova conexão: Monitor')
    
    monitor_socket = client_socket
    
    if frontend_socket:
        socketio.emit('reconnect', namespace='/')
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            received_message = handle_monitor_data(data.decode('ascii'))
            
            if frontend_socket:
                socketio.emit('monitor_message', received_message, namespace='/')
                
    except ConnectionResetError:
        print('Monitor desconectado!')
    except Exception as e:
        print(f'Erro na conexão do monitor: {e}')
    finally:
        client_socket.close()

def handle_bomb_connection(client_socket, address, bomb_number):
    """Handle bomb TCP connection"""
    global bomb1_socket, bomb2_socket, bomb3_socket, frontend_socket
    print(f'Nova conexão: Bomba de infusão {bomb_number}')
    
    if bomb_number == 1:
        bomb1_socket = client_socket
    elif bomb_number == 2:
        bomb2_socket = client_socket
    elif bomb_number == 3:
        bomb3_socket = client_socket
    
    if frontend_socket:
        socketio.emit('reconnect', namespace='/')
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            bomb_data = handle_bomb_data(data)
            
            if frontend_socket:
                socketio.emit(f'bomb{bomb_number}_message', bomb_data, namespace='/')
                
    except ConnectionResetError:
        print(f'Bomba de infusão {bomb_number} desconectada!')
    except Exception as e:
        print(f'Erro na conexão da bomba {bomb_number}: {e}')
    finally:
        client_socket.close()

def create_tcp_server(port, handler, *args):
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

# WebSocket event handlers
@socketio.on('connect')
def handle_connect():
    global frontend_socket
    print('Nova conexão: Frontend')
    frontend_socket = True

@socketio.on('disconnect')
def handle_disconnect():
    global frontend_socket
    print('Frontend desconectado')
    frontend_socket = None

@socketio.on('silent_bomb1')
def handle_silent_bomb1(serial_number):
    global bomb1_socket
    if bomb1_socket:
        try:
            bomb1_socket.send(send_silent_alarm(serial_number))
            print('Comando para silenciar bomba 1 enviado!')
            print(serial_number)
        except Exception as e:
            print(f'Erro ao silenciar bomba 1: {e}')

@socketio.on('silent_bomb2')
def handle_silent_bomb2(serial_number):
    global bomb2_socket
    if bomb2_socket:
        try:
            bomb2_socket.send(send_silent_alarm(serial_number))
            print('Comando para silenciar bomba 2 enviado!')
        except Exception as e:
            print(f'Erro ao silenciar bomba 2: {e}')

@socketio.on('silent_bomb3')
def handle_silent_bomb3(serial_number):
    global bomb3_socket
    if bomb3_socket:
        try:
            bomb3_socket.send(send_silent_alarm(serial_number))
            print('Comando para silenciar bomba 3 enviado!')
        except Exception as e:
            print(f'Erro ao silenciar bomba 3: {e}')

@socketio.on('refresh_bomb1')
def handle_refresh_bomb1(serial_number):
    global bomb1_socket
    if bomb1_socket:
        try:
            bomb1_socket.send(send_refresh_alarm(serial_number))
            print('Comando para reativar alarmes bomba 1 enviado!')
        except Exception as e:
            print(f'Erro ao reativar alarmes bomba 1: {e}')

@socketio.on('refresh_bomb2')
def handle_refresh_bomb2(serial_number):
    global bomb2_socket
    if bomb2_socket:
        try:
            bomb2_socket.send(send_refresh_alarm(serial_number))
            print('Comando para reativar alarmes bomba 2 enviado!')
        except Exception as e:
            print(f'Erro ao reativar alarmes bomba 2: {e}')

@socketio.on('refresh_bomb3')
def handle_refresh_bomb3(serial_number):
    global bomb3_socket
    if bomb3_socket:
        try:
            bomb3_socket.send(send_refresh_alarm(serial_number))
            print('Comando para reativar alarmes bomba 3 enviado!')
        except Exception as e:
            print(f'Erro ao reativar alarmes bomba 3: {e}')

@socketio.on('disconnect_bomb1')
def handle_disconnect_bomb1():
    print('Bomba de infusão 1 desconectada por inatividade. Listeners excluídos!')

@socketio.on('disconnect_bomb2')
def handle_disconnect_bomb2():
    print('Bomba de infusão 2 desconectada por inatividade. Listeners excluídos!')

@socketio.on('disconnect_bomb3')
def handle_disconnect_bomb3():
    print('Bomba de infusão 3 desconectada por inatividade. Listeners excluídos!')

if __name__ == '__main__':
    # Start TCP servers in separate threads
    tcp_servers = [
        (22001, handle_bomb_connection, 1),  # Bomb 1
        (22002, handle_bomb_connection, 2),  # Bomb 2
        (22003, handle_bomb_connection, 3),  # Bomb 3
        (23000, handle_ventilator_connection),  # Ventilator
        (2222, handle_monitor_connection),   # Monitor
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
    socketio.run(app, host='0.0.0.0', port=4444, debug=False, allow_unsafe_werkzeug=True)
