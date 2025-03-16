create_wave_config  wave.wcfg
add_wave_group SPI_COMMAND_HANDLER
add_wave_group SPI_DRIVER
add_wave -into SPI_COMMAND_HANDLER  /spi_command_handler_tb/UUT/*
add_wave -into SPI_DRIVER  /spi_command_handler_tb/UUT/SPI_INSTANTATION/*