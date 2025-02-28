`timescale 1ns/1ps
module uart_tb 
(
);

`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"

// LOCAL PARAMETER 
// ---
localparam  HIGH    = 1'b1;
localparam  LOW     = 1'b0;
localparam  DRST    = 32'b0;
localparam  NANOSEC = 1_000_000_000;
// ---

// CLOCK GENERATION 
reg clk;
// ---
initial 
begin
    clk = LOW;
    //OFFSET
    #50;
    forever 
    begin
        #50;
        clk = !clk;    
    end    
end
// ---



// RESET GENERATION 
reg rstb;
// ---
initial
begin
    rstb = LOW;
    #100;
    rstb = HIGH;
end
// ---


// data_in
reg [CAC_UART_BITLEN-1:0] data_in;
reg in_write;
// ---
initial
begin
    data_in     = DRST;
    in_write    = LOW;
    #500;
    @(posedge clk);
    data_in     = 5;
    in_write    = HIGH;
    @(posedge clk);
    data_in     = 9;
    in_write    = HIGH;
    @(posedge clk);
    data_in     = DRST;
    in_write    = LOW;
end
// ---

// RX
reg rx;
reg out_read;
// ---
initial
begin
    out_read = LOW;
    rx = HIGH;                  // IDLE
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // START
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // DATA MSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                  // DATA LSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                  // STOP
    #(NANOSEC/CAC_UART_BAUDRATE);

    rx = HIGH;                  // IDLE
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // START
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // DATA MSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // DATA LSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                  // STOP
    #(NANOSEC/CAC_UART_BAUDRATE);
    @(posedge clk);
    out_read = HIGH;
    @(posedge clk);
    @(posedge clk);
    out_read = LOW;
end
// ---



// UUT
wire tx;
wire [CAC_UART_BITLEN-1:0] data_out;
wire out_full;
wire out_empty;
wire in_full;
wire in_empty;
wire [$clog2(CAC_UART_ERRORNUM)-1:0] error_rx;
// ---
uart #(
    .BAUDRATE           (CAC_UART_BAUDRATE),
    .CLK_FREQ           (CAC_CLK_FREQUENCY),
    .BITLEN             (CAC_UART_BITLEN),
    .BUFFER_WIDTH       (CAC_UART_BUFFER_WIDTH),
    .BUFFER_LENGTH      (CAC_UART_BUFFER_DEPTH),
    .ERRORNUM           (CAC_UART_ERRORNUM)
) 
UUT
(
    .clk(clk),
    .rstb(rstb),
    .rx(rx),
    .tx(tx),
    .data_out(data_out),
    .out_full(out_full),
    .out_empty(out_empty),
    .out_read(out_read),
    .data_in(data_in),
    .in_write(in_write),
    .in_full(in_full),
    .in_empty(in_empty),
    .error_rx(error_rx)
);

// ---

endmodule