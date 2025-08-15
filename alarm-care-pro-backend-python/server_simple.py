import socket
import struct
from datetime import datetime

# Alarms dictionary (equivalent to the original server.js)
alarms_dict = {
    0: 'Oclusão',
    1: 'Vazão Livre',
    2: 'Bateria crítica',
    3: 'Infusão concluída',
    4: 'Porta Aberta',
    5: 'Erro no mecanismo',
    6: 'Ar na linha',
    7: 'Frasco Vazio',
    8: 'Erro Sens. De Gotas',
    9: 'Erro Corta-Fluxo',
    10: 'Sistema Reiniciado',
    11: 'Oclusão Superior',
    12: 'Erro no Acionador PCA',
    13: 'Solução Concluída',
    14: 'Undefined',
    15: 'Término da PAUSA',
    16: 'Deslocar Equipo',
    17: 'Trocar Equipo',
    18: 'Desconecte o Paciente',
    19: 'Registrar Balanço Hídrico',
    20: 'Fim do volume do frasco',
    21: 'Remover sens. Gotas',
    22: 'Em KTO',
    23: 'Alerta Corta-Fluxo',
    24: 'Alerta Vol. Máx. atingido',
    25: 'Modo Transporte',
    26: 'Bateria baixa',
    27: 'Em Espera',
    28: 'Pré-alarme fim de infusão',
    29: 'Pré-alarme fim do volume do frasco',
    30: 'Em KVO',
    31: 'Infusão interrompida',
}

def int_to_bin(number):
    """Convert integer to 8-bit binary string"""
    return format(number, '08b')

def handle_connection(client_socket, address):
    """Handle client connection"""
    print('Alguem se conectou!')
    
    try:
        while True:
            data = client_socket.recv(1024)
            if not data:
                break
            
            # Process the data similar to the original Node.js code
            if len(data) >= 15:
                pump_serial_number = data[0:7].decode('ascii', errors='ignore')
                timestamp_int = struct.unpack('>I', data[7:11])[0]
                timestamp = datetime.fromtimestamp(timestamp_int).strftime('%d/%m/%Y %H:%M:%S')
                infusion_id = data[12] + data[13]
                qtd_params = data[14]
                
                print('Pump serial number:', pump_serial_number)
                print('Timestamp:', timestamp)
                print('Infusion ID:', infusion_id)
                print('Number of parameters:', qtd_params)
                
                current_byte = 15
                alarms_list_len = 32
                
                for i in range(qtd_params):
                    if current_byte < len(data) and hex(data[current_byte]) == '0x6f':
                        if current_byte + 4 < len(data):
                            alarms_list = (
                                int_to_bin(data[current_byte + 1]) +
                                int_to_bin(data[current_byte + 2]) +
                                int_to_bin(data[current_byte + 3]) +
                                int_to_bin(data[current_byte + 4])
                            )
                            
                            print('ACTIVE ALARMS P*:', alarms_list)
                            
                            current_byte += 5
                            
                            if alarms_list.replace('0', '') == '':
                                print('\n!!! NÃO HÁ ALARMES ATIVOS !!!\n')
                            else:
                                for j in range(alarms_list_len):
                                    alarm = alarms_list[-1]
                                    alarms_list = alarms_list[:-1]
                                    
                                    if alarm == '1':
                                        print(f'\n!!! ALARME ATIVO: {alarms_dict[j]} !!!\n')
                            print()
            
    except ConnectionResetError:
        print('Cliente desconectou!')
    except Exception as e:
        print(f'Erro na conexão: {e}')
    finally:
        client_socket.close()

def main():
    """Main server function"""
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server_socket.bind(('0.0.0.0', 22000))
    server_socket.listen(5)
    
    print('Server listening on 0.0.0.0:22000')
    
    try:
        while True:
            client_socket, address = server_socket.accept()
            handle_connection(client_socket, address)
    except KeyboardInterrupt:
        print('\nServer shutting down...')
    finally:
        server_socket.close()

if __name__ == '__main__':
    main()
