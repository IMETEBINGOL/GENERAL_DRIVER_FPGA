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
reg     rstb    = HIGH;
// ---
initial
begin
    rstb        = LOW;
    #(10*CLK_PERIOD);
    rstb        = HIGH;
end
// ---

endmodule