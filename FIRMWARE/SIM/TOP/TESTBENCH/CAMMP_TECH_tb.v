`timescale 1ns/1ps
module CAMMP_TECH_tb
(

);
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"
`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "SYSTEM_PARAMETER.vh"


// LOCAL PARAMETER
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'd0;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLK_PERIOD              = SECOND_IN_NANOSECOND/MASTER_CLOCK_FREQUENCY;
// ---

reg     clk             = LOW;
reg     rst             = HIGH;
reg     cac_uart_rx     = HIGH;
wire    cac_uart_tx;

// CLOCK GENERATION
// ---  
initial 
begin
    #(10*CLK_PERIOD);
    forever 
    begin
        #(CLK_PERIOD/2);
        clk = !clk;
    end    
end
// ---


// RESET GENERATION 
// ---
initial
begin
    #(CLK_PERIOD*100);
    rst     = LOW;
end
// ---

// DATA SEND
// ---
initial
begin
    #(CLK_PERIOD*1000);
    cac_uart_rx = LOW;      // START
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 7
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 6
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 5
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 4
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 3
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 2
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 1
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 0
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // STOP
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);

    // ---

    cac_uart_rx = LOW;      // START
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 7
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 6
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 5
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;     // 4
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 3
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 2
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 1
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 0
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // STOP
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);

    cac_uart_rx = LOW;      // START
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 7
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 6
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 5
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 4
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 3
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 2
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 1
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 0
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // STOP
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);

    cac_uart_rx = LOW;      // START
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 7
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 6
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 5
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 4
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 3
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 2
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 1
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 0
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // STOP
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);


    cac_uart_rx = LOW;      // START
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 7
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 6
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 5
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // 4
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 3
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 2
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 1
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = LOW;      // 0
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
    cac_uart_rx = HIGH;     // STOP
    #(SECOND_IN_NANOSECOND/CAC_UART_BAUDRATE);
end
// ---


CAMMMP_TECH UUT
(
    .clk                            (clk),
    .rst                            (rst),
    .cac_uart_rx                    (cac_uart_rx),
    .cac_uart_tx                    (cac_uart_tx)
);





endmodule