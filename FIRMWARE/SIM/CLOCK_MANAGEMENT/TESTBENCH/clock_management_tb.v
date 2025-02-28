`timescale 1ns/1ps
module clock_management_tb
(

);

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

// CLOCK GENERATION
reg     clk = LOW;
// ---
initial 
begin
    clk         = LOW;
    #(CLK_PERIOD/2);
    forever 
    begin
        #(CLK_PERIOD/2);
        clk     = ~clk;
    end
end
// ---

// RESET GENERATION 
reg     rst = LOW;
// ---
initial
begin
    rst     = HIGH;
    #(10*CLK_PERIOD);
    rst     = LOW;
end
// ---

// UUT INSTANTATION
wire    clk_f100_p0;
wire    clk_f10_p0;
wire    rstb_f100_p0;
wire    rstb_f10_p0;
// ---
clock_management #(
    .CLK_FREQUENCY  (MASTER_CLOCK_FREQUENCY)
) 
UUT
(
    .clk_in         (clk),
    .rst            (rst),
    .clk_f100_p0    (clk_f100_p0),
    .clk_f10_p0     (clk_f10_p0),
    .rstb_f100_p0   (rstb_f100_p0),
    .rstb_f10_p0    (rstb_f10_p0)
);
// ---





endmodule