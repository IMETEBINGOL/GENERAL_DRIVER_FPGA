// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE SYNCHRONIZE RESET AND CLOCK GENERATED. 
// 
// ---

module clock_management 
#(
    parameter           CLK_FREQUENCY   = 100_000_000
) 
(
    input               clk_in,
    input               rst,
    output              clk_f100_p0,
    output              clk_f10_p0,
    output              rstb_f100_p0,
    output              rstb_f10_p0
);

// PORT UPPER ASSIGMENT 
// ---

// ---

// LOCAL PARAMETER 
// ---
localparam  HIGH        = 1'b1;
localparam  LOW         = 1'b0;
localparam  DRST        = 32'd0;
// ---

// LOCAL VARIABLE 
// ---
wire clk_out_0;
wire clk_out_1;
wire rstb;
wire rstb_out_0;
wire rstb_out_1;
// ---


// CLOCK GENERATION INSTANTATION
// ---
clock_generation #(
    .CLK_FREQUENCY      (CLK_FREQUENCY)
) 
CLOCK_GENERATION_INSTANTATION
(
    .clk_in             (clk_in),
    .rst                (rst),
    .rstb               (rstb),
    .clk_out_0          (clk_out_0),
    .clk_out_1          (clk_out_1)
);
// ---


// RESET SYNCHRONIZER INSTANTATIONs
// ---
reset_synchronizer RESET_SYNCHRONIZER_INSTANTATION_0(.clk(clk_out_0), .rstb_in(rstb), .rstb_out(rstb_out_0));
reset_synchronizer RESET_SYNCHRONIZER_INSTANTATION_1(.clk(clk_out_1), .rstb_in(rstb), .rstb_out(rstb_out_1));
// ---


// PORT LOWER ASSIGMENT 
// ---
assign  clk_f100_p0     = clk_out_0;
assign  clk_f10_p0      = clk_out_1;
assign  rstb_f100_p0    = rstb_out_0;
assign  rstb_f10_p0     = rstb_out_1;
// ---
endmodule
