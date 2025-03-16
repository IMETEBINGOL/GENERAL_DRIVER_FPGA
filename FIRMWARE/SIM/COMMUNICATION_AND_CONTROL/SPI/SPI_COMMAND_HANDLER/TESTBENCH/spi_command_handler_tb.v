`timescale 1ns/1ps
module spi_command_handler_tb
(

);

`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"


// LOCAL PARAMETER
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'd0;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLK_PERIOD              = SECOND_IN_NANOSECOND/CAC_CLK_FREQUENCY;
// ---

reg     [CAC_SPI_PACKAGE_WIDTH-1:0]     cmd         = DRST;
reg     [CAC_SPI_PACKAGE_WIDTH-1:0]     data_in     = DRST;
reg     [CAC_SPI_PACKAGE_WIDTH-2:0]     addr_in     = DRST;
reg                                     exec        = LOW;
reg                                     sdi         = LOW;

// CLOCK GENERATION
wire        clk;
// ---
clock_generation_sim #(
    .CLK_1_FREQUENCY                    (CAC_CLK_FREQUENCY),
    .CLK_1_INITIALIZING_DELAY           (0),
    .CLK_1_PHASE                        (0)
) 
CLOCK_GENERATION
(
    .clk_out_1                          (clk)
);
// ---

// RESET GENERATION 
reg                                     rstb    = HIGH;
// ---
initial
begin
    rstb        = LOW;
    #(10*CLK_PERIOD);
    rstb        = HIGH;
end
// ---

// SPI COMMAND HANDLER
wire                                busy;
wire [CAC_SPI_PACKAGE_WIDTH-1:0]    data_out;
wire                                csb;
wire                                sdo;
// ---
spi_command_handler #(
    .PACKAGE_SIZE                       (CAC_SPI_PACKAGE_WIDTH)
) 
UUT
(
    .clk                                (clk),
    .rstb                               (rstb),
    .cmd                                (cmd),
    .data_in                            (data_in),
    .addr_in                            (addr_in),
    .exec                               (exec),
    .busy                               (busy),
    .data_out                           (data_out),
    .sdi                                (sdi),
    .csb                                (csb),
    .sdo                                (sdo)
);
// ---


// TEST 
// ---
initial
begin
    #(20*CLK_PERIOD);
    @(posedge clk);
    cmd         = 8'h01;        // WRITE
    addr_in     = 8'h05;
    data_in     = 8'h27;
    exec        = HIGH;
    @(posedge clk)
    exec        = LOW;
    @(posedge csb);
    #(20*CLK_PERIOD);
    @(posedge clk);
    cmd         = 8'h02;        // READ
    addr_in     = 8'h07;
    exec        = HIGH;
    @(negedge csb)
    exec        = LOW;
    sdi         = HIGH;
    repeat(16)
    begin
        @(negedge clk);
        sdi     = !sdi; 
    end
    if (data_out == 8'haa)
    begin
        $display("TEST PASSED.");
    end
    else
    begin
        $display("TEST FAILED.");
    end
    $finish;
end
// ---

endmodule