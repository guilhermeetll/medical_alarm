def int_to_bin(number):
    """Convert integer to 8-bit binary string"""
    if isinstance(number, str):
        number = int(number, 10)
    return format(number, '08b')
