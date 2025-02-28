create_wave_config  wave.wcfg
add_wave_group UART
add_wave_group UART_TX
add_wave_group UART_RX
add_wave_group UART_RX_CIRCULAR_BUFFER
add_wave_group UART_TX_CIRCULAR_BUFFER
add_wave -into UART  /uart_tb/UUT/*
add_wave -into UART_RX  /uart_tb/UUT/UART_RX_INSTANTATION/*
add_wave -into UART_TX  /uart_tb/UUT/UART_TX_INSTANTATION/*
add_wave -into UART_RX_CIRCULAR_BUFFER  /uart_tb/UUT/CIRCULAR_BUFFER_UART_RX_INSTANTATION/*
add_wave -into UART_TX_CIRCULAR_BUFFER  /uart_tb/UUT/CIRCULAR_BUFFER_UART_TX_INSTANTATION/*