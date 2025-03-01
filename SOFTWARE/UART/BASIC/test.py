import serial

def send_hex_uart(port, hex_number, msb_first=True):
    """
    Sends a 2-digit hexadecimal number over UART.
    :param port: UART port (e.g., 'COM14')
    :param hex_number: String representing a 2-digit hex number (e.g., 'A5')
    :param msb_first: Boolean, if True sends MSB first, otherwise sends LSB first
    """
    try:
        ser = serial.Serial(port, baudrate=9600, timeout=1)
        
        if len(hex_number) != 2:
            print("Error: Input must be a 2-digit hexadecimal number.")
            return
        
        byte1 = bytes.fromhex(hex_number)  # Convert hex string to byte
        
        if msb_first:
            ser.write(byte1)  # Send MSB first
        else:
            ser.write(byte1[::-1])  # Reverse and send LSB first
        
        print(f"Sent {hex_number} over {port} in {'MSB' if msb_first else 'LSB'} first mode.")
        
        # Check if there is incoming data
        while ser.in_waiting:
            received_data = ser.read().hex().upper()
            print(f"Received: {received_data}")
        
        ser.close()
    except serial.SerialException as e:
        print(f"Serial error: {e}")
    except ValueError:
        print("Invalid hexadecimal input.")

if __name__ == "__main__":
    port = "COM14"  # Change this according to your system
    order = input("Enter order (MSB or LSB): ").strip().upper()
    msb_first = order == "MSB"
    
    while True:
        hex_number = input("Enter a 2-digit hexadecimal number (e.g., A5) or 'exit' to quit: ").strip().upper()
        if hex_number == "EXIT":
            break
        send_hex_uart(port, hex_number, msb_first)
