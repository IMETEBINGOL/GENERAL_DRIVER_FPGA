// ---
//  ENG: IBRAHIM METE BINGOL
//  PROJECT: CAMMP_TECH
// ---
module CAMMMP_TECH 
(
    // CLOCK AND RESET
    // ---
    input                                   clk_ref,
    input                                   rst,
    input                                   cac_uart_rx,
    output                                  cac_uart_tx
    // ---

);


// PARAMETER INITIALIZING 
// ---
`include "SYSTEM_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"
`include "CLOCK_MANAGEMENT_PARAMETER.vh"
// ---



// CLOCK AND REST MANAGEMENT MANAGEMENT 
wire                                        clk_f100_p0;
wire                                        clk_f10_p0;
wire                                        rstb_f100_p0;
wire                                        rstb_f10_p0;
// ---
clock_management #(
    .CLK_FREQUENCY                          (MASTER_CLOCK_FREQUENCY)
) 
CLOCK_MANAGEMENT_INSTANTATION
(
    .clk_in                                 (clk_ref),
    .rst                                    (!rst),
    .clk_f100_p0                            (clk_f100_p0),
    .clk_f10_p0                             (clk_f10_p0),
    .rstb_f100_p0                           (rstb_f100_p0),
    .rstb_f10_p0                            (rstb_f10_p0)
);
// ---


// COMMUNICATION AND CONTROL 
// ---
communication_and_control #(
    .CAC_SETTINGS_MEMORY_WIDTH              (CAC_SETTINGS_MEMORY_WIDTH),
    .CAC_SETTINGS_ROM_MEMORY_LENGTH         (CAC_SETTINGS_ROM_MEMORY_LENGTH),
    .CAC_SETTINGS_RAM_MEMORY_LENGTH         (CAC_SETTINGS_RAM_MEMORY_LENGTH),
    .CAC_UART_BAUDRATE                      (CAC_UART_BAUDRATE),   
    .CAC_UART_CLK_FREQ                      (CAC_CLK_FREQUENCY),
    .CAC_UART_BITLEN                        (CAC_UART_BITLEN),
    .CAC_UART_BUFFER_WIDTH                  (CAC_UART_BUFFER_WIDTH),
    .CAC_UART_BUFFER_LENGTH                 (CAC_UART_BUFFER_DEPTH),
    .CAC_UART_ERRORNUM                      (CAC_UART_ERRORNUM),
    .CAC_UART_CH_BUFFER_WIDTH               (CAC_BUFFER_WIDTH),
    .CAC_UART_CH_SETTINGS_ADDR_WIDTH        (CAC_BUFFER_WIDTH),
    .CAC_UART_CH_SETTINGS_DATA_WIDTH        (CAC_SETTINGS_MEMORY_WIDTH)
) 
CAC 
(   
    .clk_cac                                (clk_f10_p0),
    .rstb_cac                               (rstb_f10_p0),
    .uart_rx                                (cac_uart_rx),
    .uart_tx                                (cac_uart_tx)
);
// ---
endmodule