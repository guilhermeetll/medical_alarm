import struct
import time

def send_refresh_alarm(bomb_serial: str) -> bytes:
    """Send refresh alarm command to bomb"""
    
    # Using predefined hex messages for specific bomb serials (as in original code)
    hex_bomb_serial = bomb_serial.encode('ascii').hex()
    if len(bomb_serial) == 7:
        hex_bomb_serial += '00'
    
    hex_refresh_alarm_message = ''
    if bomb_serial == '04237BE':
        hex_refresh_alarm_message = hex_bomb_serial + '650F677C0000017000B4372F93'
    elif bomb_serial == '04505BE':
        hex_refresh_alarm_message = hex_bomb_serial + '650F66F80000017000105DED63'
    elif bomb_serial == '04230BE':
        hex_refresh_alarm_message = '30343233304245006569C24600000170006FB258F5'
    
    return bytes.fromhex(hex_refresh_alarm_message)
