// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE CREATE ROM AND RAM FOR SYSTEM 
// 
// ---
module settings
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
    


regmem #(
    .MEMORY_WIDTH(MEMORY_WIDTH),
    .ROM_MEMORY_LENGTH(ROM_MEMORY_LENGTH),
    .RAM_MEMORY_LENGTH(RAM_MEMORY_LENGTH)
) 
REGMEM_INSTANTATION
(
    .clk(clk),
    .rstb(rstb),
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





endmodule