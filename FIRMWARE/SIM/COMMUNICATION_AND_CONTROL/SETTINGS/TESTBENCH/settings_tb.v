`timescale 1ns/1ps
module settings_tb
(

);

`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"
`include "CLOCK_MANAGEMENT_PARAMETER.vh"


// LOCAL PARAMETER
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'd0;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLK_PERIOD              = SECOND_IN_NANOSECOND/CAC_CLK_FREQUENCY;
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
    rst     = LOW;
    #(10*CLK_PERIOD);
    rst     = HIGH;
end
// ---

wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_0 = 0; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_1 = 1; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_2 = 2; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_3 = 3; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_4 = 4; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_5 = 5; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_6 = 6; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_7 = 7; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_8 = 8; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_9 = 9; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_10 = 10; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_11 = 11; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_12 = 12; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_13 = 13; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_14 = 14; 
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] rom_data_15 = 15;
reg     [$clog2(CAC_SETTINGS_ROM_MEMORY_LENGTH + CAC_SETTINGS_RAM_MEMORY_LENGTH) -1:0] addr;
reg     [CAC_SETTINGS_MEMORY_WIDTH -1:0] data_in;
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] data_out;
wire    [CAC_SETTINGS_MEMORY_WIDTH -1:0] ram_data_out_0;
reg     wen;

initial
begin
    wen         = LOW;
    addr        = DRST;
    data_in     = DRST;
    #(30 * CLK_PERIOD);
    addr        = 0 + CAC_SETTINGS_ROM_MEMORY_LENGTH;
    data_in     = 16;
    wen         = HIGH;
    #(CLK_PERIOD);
    wen         = LOW;
    addr        = DRST;
    data_in     = DRST;
    if (ram_data_out_0 == 16)
    begin
        $display("AUTOMATED TEST PASSED CORRECTLY");
    end
    else
    begin
        $display("AUTOMATED TEST FAILED");
    end
    $finish;
end


// UUT INSTANTATION
// ---
settings #(
    .MEMORY_WIDTH(CAC_SETTINGS_MEMORY_WIDTH),
    .ROM_MEMORY_LENGTH(CAC_SETTINGS_ROM_MEMORY_LENGTH),
    .RAM_MEMORY_LENGTH(CAC_SETTINGS_RAM_MEMORY_LENGTH)
) 
UUT
(
    .clk(clk),
    .rstb(rst),
    .wen(wen),
    .addr(addr),
    .data_in(data_in),
    .data_out(data_out), 
    .rom_data_0(rom_data_0),   
    .rom_data_1(rom_data_1),   
    .rom_data_2(rom_data_2),   
    .rom_data_3(rom_data_3),   
    .rom_data_4(rom_data_4),   
    .rom_data_5(rom_data_5),  
    .rom_data_6(rom_data_6),   
    .rom_data_7(rom_data_7),   
    .rom_data_8(rom_data_8),   
    .rom_data_9(rom_data_9),  
    .rom_data_10(rom_data_10),  
    .rom_data_11(rom_data_11),  
    .rom_data_12(rom_data_12),  
    .rom_data_13(rom_data_13),  
    .rom_data_14(rom_data_14),  
    .rom_data_15(rom_data_15),
    .ram_data_out_0(ram_data_out_0)
);
// ---





endmodule