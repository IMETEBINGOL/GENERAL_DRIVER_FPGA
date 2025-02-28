create_wave_config  wave.wcfg
add_wave_group TOP
add_wave_group UART
add_wave_group UCH
add_wave_group MEMORY
add_wave -into TOP  /CAMMP_TECH_tb/UUT/*
add_wave -into UCH  /CAMMP_TECH_tb/UUT/CAC/UART_COMMAND_HANDLER_INSTANTATION/*
add_wave -into UART  /CAMMP_TECH_tb/UUT/CAC/UART_INSTANTATION/*
add_wave -into MEMORY  /CAMMP_TECH_tb/UUT/CAC/SYSTEM_SETTINGS/*