import serial 
import queue
import threading
import time

FUI_PORT_NAME   = "COM14"
FUI_BAUDRATE    = 115200
FUI_TIMEOUT     = 1
FUI_BYTESIZE    = 8

class FPGA_UART_INTERFACE:
    def __init__(self):
        self.FUI_ser = serial.Serial(
            port=FUI_PORT_NAME, 
            baudrate=FUI_BAUDRATE,  
            timeout=FUI_TIMEOUT, 
            bytesize=FUI_BYTESIZE
        )
        self.FUI_write_queue = queue.Queue()
        self.FUI_read_queue  = queue.Queue()
        self.running = True  # Flag to stop threads gracefully

    def send_byte(self):
        """Send data from the write queue to the FPGA."""
        while self.running:
            if not self.FUI_write_queue.empty():
                tmp = self.FUI_write_queue.get()
                self.FUI_ser.write(tmp.to_bytes(1, byteorder='big'))
            time.sleep(0.01)  # Prevent high CPU usage

    def read_byte(self):
        """Read data from FPGA and store it in the read queue."""
        while self.running:
            if self.FUI_ser.in_waiting > 0:
                tmp = self.FUI_ser.read(1)  # Read 1 byte
                self.FUI_read_queue.put(hex(tmp[0]))  # Convert byte to hex
            time.sleep(0.01)  # Prevent high CPU usage

    def stop_threads(self):
        """Stop running threads and close serial connection."""
        self.running = False
        self.FUI_ser.close()

if __name__ == "__main__":
    FUI_OBJECT = FPGA_UART_INTERFACE()
    thread_send = threading.Thread(target=FUI_OBJECT.send_byte, daemon=True)
    thread_read = threading.Thread(target=FUI_OBJECT.read_byte, daemon=True)

    thread_send.start()
    thread_read.start()

    try:
        while True:
            # Print received data if available
            while not FUI_OBJECT.FUI_read_queue.empty():
                print(f"Received: {FUI_OBJECT.FUI_read_queue.get()}")
            tmp = input("Enter HEX data (or 'exit' to quit): ").strip()
            if tmp.lower() == "exit":
                break
            FUI_OBJECT.FUI_write_queue.put(int(tmp, 16))
    except KeyboardInterrupt:
        print("\nExiting...")
    finally:
        FUI_OBJECT.stop_threads()
