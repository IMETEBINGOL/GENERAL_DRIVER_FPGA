# IMPORT AND INCLUDES
import threading
import time
import serial
import queue

# DEBUG 
DEBUG_MODE                  = False

# COMMANDS 
READ_MEMORY                 = "RDMEM"
WRITE_MEMORY                = "WRTMEM"
RESET_BUFFER                = "RSTBUF"
GET_WRITE_BUFFER_EMPTY      = "GETWBE"
GET_READ_BUFFER_EMPTY       = "GETRBE"
GET_WRITE_BUFFER_FULL       = "GETWBF"
GET_READ_BUFFER_FULL        = "GETRBF"
GET_UART_ERROR              = "GETERR"

# FUI COMMANDS 
FUI_BUFFER_RESET_COMMAND    = 0x10
FUI_MEMORY_WRITE_COMMAND    = 0x01
FUI_MEMORY_READ_COMMAND     = 0x02



# ROM ADDRESS PARAMETER 
MEMORY_ROM_LENGTH           = 16
MEMORY_ROM_WIDTH            = 16 
MEMORY_ROM_ADDRESS_0        = 0x00 
MEMORY_ROM_ADDRESS_1        = 0x01
MEMORY_ROM_ADDRESS_2        = 0x02
MEMORY_ROM_ADDRESS_3        = 0x03
MEMORY_ROM_ADDRESS_4        = 0x04
MEMORY_ROM_ADDRESS_5        = 0x05
MEMORY_ROM_ADDRESS_6        = 0x06
MEMORY_ROM_ADDRESS_7        = 0x07
MEMORY_ROM_ADDRESS_8        = 0x08
MEMORY_ROM_ADDRESS_9        = 0x09
MEMORY_ROM_ADDRESS_10       = 0x0A
MEMORY_ROM_ADDRESS_11       = 0x0B
MEMORY_ROM_ADDRESS_12       = 0x0C
MEMORY_ROM_ADDRESS_13       = 0x0D
MEMORY_ROM_ADDRESS_14       = 0x0E
MEMORY_ROM_ADDRESS_15       = 0x0F

# RAM ADDRESS PARAMETER 
MEMORY_RAM_LENGTH           = 16
MEMORY_RAM_WIDTH            = 16
MEMORY_RAM_ADDRESS_0        = 0x10
MEMORY_RAM_ADDRESS_1        = 0x11
MEMORY_RAM_ADDRESS_2        = 0x12
MEMORY_RAM_ADDRESS_3        = 0x13
MEMORY_RAM_ADDRESS_4        = 0x14
MEMORY_RAM_ADDRESS_5        = 0x15
MEMORY_RAM_ADDRESS_6        = 0x16
MEMORY_RAM_ADDRESS_7        = 0x17
MEMORY_RAM_ADDRESS_8        = 0x18
MEMORY_RAM_ADDRESS_9        = 0x19
MEMORY_RAM_ADDRESS_10       = 0x1A
MEMORY_RAM_ADDRESS_11       = 0x1B
MEMORY_RAM_ADDRESS_12       = 0x1C
MEMORY_RAM_ADDRESS_13       = 0x1D
MEMORY_RAM_ADDRESS_14       = 0x1E
MEMORY_RAM_ADDRESS_15       = 0x1F

# UART PARAMETER
UART_PORT_NAME              = "COM14"
UART_BAUDRATE               = 115200
UART_TIMEOUT                = 1
UART_BYTESIZE               = 8
UART_STOPBIT                = 1
UART_WRITE_QUEUE_LENGTH     = 32
UART_READ_QUEUE_LENGTH      = 32

class UART:
    def __init__(self) -> None:
        self.uart_ser       = serial.Serial (
                                            port        =   UART_PORT_NAME,
                                            baudrate    =   UART_BAUDRATE,
                                            timeout     =   UART_TIMEOUT,
                                            bytesize    =   UART_BYTESIZE,
                                            stopbits    =   UART_STOPBIT
                                            )
        self.write_queue    = queue.Queue(UART_WRITE_QUEUE_LENGTH)
        self.read_queue     = queue.Queue(UART_READ_QUEUE_LENGTH)
        self.uart_terminate = False
    def byte_sender(self) -> None:
        tmp = 0
        while not self.uart_terminate:
            if (self.write_queue.empty()):
                time.sleep(0.1)
                if (DEBUG_MODE):
                    print("WRITE QUEUE EMPTY...")
                continue
            tmp = self.write_queue.get()
            self.uart_ser.write(tmp.to_bytes(1, byteorder = 'big'))
            time.sleep(0.01) 
    def byte_receiver(self) -> None:
        tmp = 0
        while not self.uart_terminate:
            if (self.read_queue.full()):
                time.sleep(0.1)
                if (DEBUG_MODE):
                    print("READ QEUEU FULL...")
                continue
            if (self.uart_ser.in_waiting > 0):
                tmp = self.uart_ser.read(1)
                self.read_queue.put(tmp[0])
            time.sleep(0.01)
                   
class FUI:
    def __init__(self) -> None:
        self.uart_obj               = UART()
        self.threading_function_0   = threading.Thread(target = self.uart_obj.byte_sender)
        self.threading_function_1   = threading.Thread(target = self.uart_obj.byte_receiver)
    def read_memory(self, address) -> None:
        self.uart_obj.write_queue.put(FUI_MEMORY_READ_COMMAND)
        self.uart_obj.write_queue.put(address)
        while self.uart_obj.read_queue.qsize() < 2:
            time.sleep(0.01)
        tmp_lsb = self.uart_obj.read_queue.get()
        tmp_msb = self.uart_obj.read_queue.get()
        if (DEBUG_MODE):
            print(f"READ RETURN:{hex(tmp_msb)}{hex(tmp_lsb)}")
        return tmp_lsb + tmp_msb * 256 
    def write_memory(self, address, datalsb, datamsb) ->None:
        self.uart_obj.write_queue.put(FUI_MEMORY_WRITE_COMMAND)
        self.uart_obj.write_queue.put(address)
        self.uart_obj.write_queue.put(datalsb)
        self.uart_obj.write_queue.put(datamsb)
        time.sleep(0.01)
        if(DEBUG_MODE):
            print(f"WRITE DONE...")
    def buffer_reset(self) -> None:
        self.uart_obj.write_queue.put(FUI_BUFFER_RESET_COMMAND)
        time.sleep(0.01) 
        if(DEBUG_MODE):
            print(f"BUFFER RESET DONE...")
    def get_write_buffer_empty(self) -> bool:
        return (self.read_memory(MEMORY_ROM_ADDRESS_0) & 0x0002) == 0x0002
    def get_read_buffer_empty(self) -> bool:
        return (self.read_memory(MEMORY_ROM_ADDRESS_0) & 0x0008) == 0x0008
    def get_write_buffer_full(self) -> bool:
        return (self.read_memory(MEMORY_ROM_ADDRESS_0) & 0x0001) == 0x0001
    def get_read_buffer_full(self) -> bool:
        return (self.read_memory(MEMORY_ROM_ADDRESS_0) & 0x0004) == 0x0004
    def get_uart_error(self) -> int:
        return (self.read_memory(MEMORY_ROM_ADDRESS_0) & 0x0030) >> 4
    def run(self) -> None:
        self.threading_function_0.start()
        self.threading_function_1.start()
        while True:
            command     = input("Enter Command:")
            if (command == READ_MEMORY):
                address = int(input("Enter Address:"))
                print(f"READ MEMORY:{hex(self.read_memory(address))}")
            elif (command == WRITE_MEMORY):
                address = int(input("Enter Address:"))
                data    = int(input("Enter Data:"))
                datalsb = data & 0x00FF
                datamsb = (data & 0xFF00) >> 8
                self.write_memory(address, datalsb, datamsb)
            elif (command == RESET_BUFFER):
                self.buffer_reset()
            elif (command == GET_WRITE_BUFFER_EMPTY):
                print(f"WRITE BUFFER EMPTY:{self.get_write_buffer_empty()}")
            elif (command == GET_READ_BUFFER_EMPTY):
                print(f"READ BUFFER EMPTY:{self.get_read_buffer_empty()}")
            elif (command == GET_WRITE_BUFFER_FULL):
                print(f"WRITE BUFFER FULL:{self.get_write_buffer_full()}")
            elif (command == GET_READ_BUFFER_FULL):
                print(f"READ BUFFER FULL:{self.get_read_buffer_full()}")
            elif (command == GET_UART_ERROR):
                print(f"UART ERROR:{self.get_uart_error()}")
            elif (command == "EXIT"):
                self.uart_obj.uart_terminate = True
                self.threading_function_0.join()
                self.threading_function_1.join()
                break
            else:
                print("INVALID COMMAND...")
            

if __name__ == "__main__":
    FUI_object  = FUI()
    FUI_object.run()


