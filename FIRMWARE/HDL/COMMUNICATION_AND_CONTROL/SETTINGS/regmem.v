// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE CREATE ROM AND RAM FOR SYSTEM 
// 
// ---
module regmem 
#(
    parameter               MEMORY_WIDTH                            = 16,
    parameter               ROM_MEMORY_LENGTH                       = 16,
    parameter               RAM_MEMORY_LENGTH                       = 16
) 
(
    input                                                           clk,
    input                                                           rstb,
    input                                                           wen,
    input   [$clog2(RAM_MEMORY_LENGTH + ROM_MEMORY_LENGTH) -1:0]    addr,
    input   [MEMORY_WIDTH -1:0]                                     data_in,
    output  [MEMORY_WIDTH -1:0]                                     data_out,                    
    input   [MEMORY_WIDTH -1:0]                                     rom_data_0,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_1,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_2,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_3,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_4,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_5,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_6,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_7,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_8,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_9,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_10,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_11,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_12,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_13,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_14,                      
    input   [MEMORY_WIDTH -1:0]                                     rom_data_15,
    output  [MEMORY_WIDTH -1:0]                                     ram_data_out_0               
);

// LOCAL PARAMTER
// ---
localparam      HIGH    = 1'b1;
localparam      LOW     = 1'b0;
localparam      DRST    = 32'd0;
// ---

// RAM WRITE
integer i;
reg     [MEMORY_WIDTH-1:0]  ram_memory  [0:RAM_MEMORY_LENGTH-1];
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        `include "INITIALIZING_MEMORY/RAM_INITIALIZE.vh"
    end
    else
    begin
        if (addr[$clog2(RAM_MEMORY_LENGTH + ROM_MEMORY_LENGTH) -1] && wen)
        begin
            ram_memory[addr[$clog2(RAM_MEMORY_LENGTH + ROM_MEMORY_LENGTH) -2:0]]    <= data_in;
        end
    end
end
// ---

// ROM WRITE
wire [MEMORY_WIDTH-1:0]  rom_memory  [0:ROM_MEMORY_LENGTH-1];
// ---
`include "INITIALIZING_MEMORY/ROM_INITIALIZE.vh"
// ---

// MEMORY CONCATENATE
wire [MEMORY_WIDTH-1:0] memory [0:ROM_MEMORY_LENGTH + RAM_MEMORY_LENGTH -1];
// ---
genvar j;
generate
    for (j = 0; j < ROM_MEMORY_LENGTH; j = j + 1)
    begin
        assign memory[j] = rom_memory[j];
    end
    for (j = 0; j < RAM_MEMORY_LENGTH; j = j + 1)
    begin
        assign memory[ROM_MEMORY_LENGTH + j] = ram_memory[j];
    end
endgenerate
// ---


// MEMORY READ
// ---
assign data_out         = memory[addr];
assign ram_data_out_0   = ram_memory[0];
// ---

endmodule