`timescale 1ns/1ps
module uart_tb 
(
);

`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"

// LOCAL PARAMETER 
// ---
localparam  HIGH        = 1'b1;
localparam  LOW         = 1'b0;
localparam  DRST        = 32'b0;
localparam  NANOSEC     = 1_000_000_000;
localparam  CLK_PERIOD  = NANOSEC/CAC_CLK_FREQUENCY;
// ---

// CLOCK GENERATION
wire        clk;
// ---
clock_generation_sim #(
    .CLK_1_FREQUENCY(CAC_CLK_FREQUENCY),
    .CLK_1_INITIALIZING_DELAY(0),
    .CLK_1_PHASE(0)
) 
CLOCK_GENERATION
(
    .clk_out_1(clk)
);
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
    #(CLK_PERIOD * 1000);
    @(posedge clk);
    data_in     = 5;
    in_write    = HIGH;
    @(posedge clk);
    data_in     = 9;
    in_write    = HIGH;
    @(posedge clk);
    data_in     = DRST;
    in_write    = LOW;
    // VISUAL TEST MORE EFFECIENT
end
// ---

// RX
reg rx;
reg out_read;
integer condition;
// ---
initial
begin
    condition = DRST;
    out_read = LOW;
    rx = HIGH;                  // IDLE
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // START
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                 // DATA MSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
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
    rx = LOW;                   // DATA LSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                  // STOP
    #(NANOSEC/CAC_UART_BAUDRATE);

    rx = HIGH;                  // IDLE
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // START
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // DATA MSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = LOW;                  // DATA LSB
    #(NANOSEC/CAC_UART_BAUDRATE);
    rx = HIGH;                  // STOP
    #(NANOSEC/CAC_UART_BAUDRATE);
    @(posedge clk);
    out_read = HIGH;
    @(posedge clk);
    if (data_out == 3)
    begin
        condition = condition + 1;
    end
    @(posedge clk);
    if (data_out == 6)
    begin
        condition = condition + 1;
    end
    out_read = LOW;
    if (condition == 2)
    begin
        $display("TEST PASSED SUCCESFULLY.");
    end
    else
    begin
        $display("TEST DID NOT PASS SUCCESFULLY.");
    end
    $finish;
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