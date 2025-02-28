// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE MAKE CREATE INSTANTATION FOR CLOCK GENERATION AND MAKE CONFIGURATION. 
// 
// ---

/*
CLOCK JITTER: Variation in the timing of clock signal
CLOCK SKEW: The difference in arrival times of a clock signal at different points
CLOCK OCW MUST BE 600.000 AND 1.600.000
*/

module clock_generation 
#(
    parameter           CLK_FREQUENCY   = 100_000_000
) 
(
    input               clk_in,
    input               rst,
    output              rstb,
    output              clk_out_0,
    output              clk_out_1
);


// PORT UPPER ASSIGMENT 
wire mmcm_rst;
// ---
assign mmcm_rst     = rst;
// ---

// LOCAL PARAMETER
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'd0;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLOCK_PERIOD            = SECOND_IN_NANOSECOND/CLK_FREQUENCY;
// ---

// LOCAL VARIABLE 
// ---
wire mmcm_feedback;
wire mmcm_locked;
wire CLKOUT0;
wire CLKOUT0B;
wire CLKOUT1;
wire CLKOUT1B;
wire CLKOUT2;
wire CLKOUT2B;
wire CLKOUT3;
wire CLKOUT3B;
wire CLKOUT4;
wire CLKOUT5;
wire CLKOUT6;

// ---

MMCME2_BASE #(
    .BANDWIDTH                  ("OPTIMIZED"),      // OPTIMIZATION PARAMETER FOR JITTER (OPTIONS: OPTIMIZED, HIGH, LOW), TYPE => STRING 
    .CLKFBOUT_MULT_F            (45.0),             // MULTIPLICATION PARAMETER FOR ALL CLOCK OUT,  RANGE => 2.000-64.000              
    .CLKFBOUT_PHASE             (0.0),              // PHASE OFFSET FOR ALL CLOCK OUT, RANGE => -360.000-360.000
    .CLKIN1_PERIOD              (CLOCK_PERIOD),     // CLOCK PERIOD IN NANOSECOND, EXAMPLE: 33.333 nanosecond 
    .CLKOUT1_DIVIDE             (90),               // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT2_DIVIDE             (1),                // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT3_DIVIDE             (1),                // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT4_DIVIDE             (1),                // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT5_DIVIDE             (1),                // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT6_DIVIDE             (1),                // CLOCK DIVISION FOR CLOCK, RANGE => 1-128
    .CLKOUT0_DIVIDE_F           (9),                // DIVISION PARAMETER FOR ALL CLOCK OUT, RANGE =>    
    .CLKOUT0_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT1_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT2_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT3_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT4_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT5_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT6_DUTY_CYCLE         (0.5),              // CLOCK DUTY CYCLE FOR CLOCK, RANGE => 0.01-0.99
    .CLKOUT0_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT1_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT2_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT3_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT4_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT5_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT6_PHASE              (0.0),              // CLOCK PHASE FOR CLOCK, RANGE => -360.000-360.000       
    .CLKOUT4_CASCADE            ("FALSE"),          // RESEARCH THIS AND UNDERSTAND          
    .DIVCLK_DIVIDE              (5),                // DIVISION FOR ALL CLOCK => 1-106
    .REF_JITTER1                (0.0),              // INPUT CLOCK JITTER
    .STARTUP_WAIT               ("FALSE")           // RESEARCH THIS      
)
MMCM_INSTANTATION 
(
      .CLKOUT0                  (CLKOUT0),          // CLOCK
      .CLKOUT0B                 (CLKOUT0B),         // CLOCK INVERTED
      .CLKOUT1                  (CLKOUT1),          // CLOCK
      .CLKOUT1B                 (CLKOUT1B),         // CLOCK INVERTED
      .CLKOUT2                  (CLKOUT2),          // CLOCK
      .CLKOUT2B                 (CLKOUT2B),         // CLOCK INVERTED
      .CLKOUT3                  (CLKOUT3),          // CLOCK
      .CLKOUT3B                 (CLKOUT3B),         // CLOCK INVERTED
      .CLKOUT4                  (CLKOUT4),          // CLOCK  
      .CLKOUT5                  (CLKOUT5),          // CLOCK  
      .CLKOUT6                  (CLKOUT6),          // CLOCK  
      .CLKFBOUT                 (mmcm_feedback),    // CLOCK FEEDBACK OUT
      .CLKFBOUTB                (),                 // CLOCK FEEDBACK OUT INVERTED  RESEARCH
      .LOCKED                   (mmcm_locked),      // CLOKCs LOCKED SIGNAL 
      .CLKIN1                   (clk_in),           // CLOCK IN
      .PWRDWN                   (PWRDWN),           // POWER DOWN SIGNAL 
      .RST                      (mmcm_rst),         // RESET MMCM           
      .CLKFBIN                  (mmcm_feedback)     // CLOCK FEEDBACK IN 
);


// PORT LOWER ASSIGMENT 
// ---
assign clk_out_0    = CLKOUT0; 
assign clk_out_1    = CLKOUT1; 
assign rstb         = mmcm_locked;
// ---
endmodule