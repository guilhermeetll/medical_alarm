import struct
from datetime import datetime
from typing import Dict, Any
from .int_to_bin import int_to_bin

alarms_dict: Dict[int, str] = {
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

def handle_bomb_data(data: bytes) -> Dict[str, Any]:
    """Handle bomb data and return alarm information"""
    
    pump_serial_number = data[0:7].decode('ascii')
    timestamp_int = struct.unpack('>I', data[8:12])[0] * 1000
    timestamp = datetime.fromtimestamp(timestamp_int / 1000).strftime('%d/%m/%Y %H:%M:%S')
    infusion_id = data[12] + data[13]
    qtd_params = data[14]
    
    current_byte = 15
    alarms_list_len = 32
    
    for i in range(qtd_params):
        if hex(data[current_byte]) == '0x6f':
            alarms_list = (
                int_to_bin(data[current_byte + 1]) +
                int_to_bin(data[current_byte + 2]) +
                int_to_bin(data[current_byte + 3]) +
                int_to_bin(data[current_byte + 4])
            )
            
            current_byte += 5
            
            if alarms_list.replace('0', '') == '':
                # No active alarms
                pass
            else:
                for j in range(alarms_list_len):
                    alarm = alarms_list[-1]
                    alarms_list = alarms_list[:-1]
                    
                    if alarm == '1':
                        return {
                            'pumpSerialNumber': pump_serial_number,
                            'cod': j,
                            'state': 'ACTIVE',
                            'message': 'ALARME ATIVO: ' + alarms_dict[j],
                            'updatedAt': datetime.now().isoformat()
                        }
    
    return {
        'pumpSerialNumber': pump_serial_number,
        'cod': -1,
        'state': 'ACTIVE',
        'message': 'NÃO HÁ ALARMES ATIVOS',
        'updatedAt': datetime.now().isoformat()
    }
