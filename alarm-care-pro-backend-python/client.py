import socket
import time

def main():
    """Simple TCP client to connect to the server"""
    client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    
    try:
        client_socket.connect(('0.0.0.0', 22000))
        print('Conectei com sucesso!')
        
        # Send a simple message
        client_socket.send(b'ola')
        
        # Keep connection alive
        while True:
            time.sleep(1)
            
    except Exception as e:
        print(f'Erro na conexão: {e}')
    finally:
        client_socket.close()

if __name__ == '__main__':
    main()
