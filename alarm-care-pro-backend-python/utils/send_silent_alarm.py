import struct
import time
import crcmod

def send_silent_alarm(bomb_serial: str) -> bytes:
    """Send silent alarm command to bomb"""
    
    # Using predefined hex messages for specific bomb serials (as in original code)
    hex_bomb_serial = bomb_serial.encode('ascii').hex()
    if len(bomb_serial) == 7:
        hex_bomb_serial += '00'
    
    hex_silent_alarm_message = ''
    if bomb_serial == '04237BE':
        hex_silent_alarm_message = '30343233374245006569CD450000017280000000B9A517DC'
    elif bomb_serial == '04505BE':
        hex_silent_alarm_message = '30343530354245006569CEE10000017240000000A883E5BA'
    elif bomb_serial == '04230BE':
        hex_silent_alarm_message = '30343233304245006569CF8A0000017240000000519A1D0B'
    
    return bytes.fromhex(hex_silent_alarm_message)
