module communication_and_control 
#(
    parameter                                   CAC_SETTINGS_MEMORY_WIDTH           = 16,
    parameter                                   CAC_SETTINGS_ROM_MEMORY_LENGTH      = 16,
    parameter                                   CAC_SETTINGS_RAM_MEMORY_LENGTH      = 16,
    parameter                                   CAC_UART_BAUDRATE                   = 115200,
    parameter                                   CAC_UART_CLK_FREQ                   = 100_000_000,
    parameter                                   CAC_UART_BITLEN                     = 8,
    parameter                                   CAC_UART_BUFFER_WIDTH               = 8,
    parameter                                   CAC_UART_BUFFER_LENGTH              = 16,
    parameter                                   CAC_UART_ERRORNUM                   = 3,
    parameter                                   CAC_UART_CH_BUFFER_WIDTH            = 8,
    parameter                                   CAC_UART_CH_SETTINGS_ADDR_WIDTH     = 8,
    parameter                                   CAC_UART_CH_SETTINGS_DATA_WIDTH     = 16
) 
(
    input                                       clk_cac,
    input                                       rstb_cac,
    input                                       uart_rx,
    output                                      uart_tx,
    output reg  [15:0]                          debug_leds,
    input       [2:0]                           debug_switch
);


// LOCAL PARAMETER 
// ---
localparam                                      SETTINGS_ADDR_WIDTH     = $clog2(CAC_SETTINGS_RAM_MEMORY_LENGTH + CAC_SETTINGS_ROM_MEMORY_LENGTH);
localparam                                      HIGH                    = 1'b1;
localparam                                      LOW                     = 1'b0;
localparam                                      DRST                    = 32'b0;
// ---


// LOCAL VARIABLE
// ---
wire                                            settings_wen;
wire    [SETTINGS_ADDR_WIDTH-1:0]               settings_addr;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_data_in;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_data_out;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_0;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_1;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_2;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_3;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_4;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_5;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_6;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_7;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_8;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_9;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_10;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_11;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_12;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_13;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_14;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_rom_data_15;
wire    [CAC_SETTINGS_MEMORY_WIDTH-1:0]         settings_mem_out_0;
wire    [CAC_UART_BITLEN-1:0]                   uart_data_out;
wire                                            uart_out_full;
wire                                            uart_out_empty;
wire                                            uart_out_read;
wire    [CAC_UART_BITLEN-1:0]                   uart_data_in;
wire                                            uart_in_full;
wire                                            uart_in_empty;
wire                                            uart_in_write;
wire    [$clog2(CAC_UART_ERRORNUM)-1:0]         uart_error_rx;
wire                                            uart_ch_uart_rst;
// ---





// UART COMMAND HANDLER INSTANTATION
// ---
uart_command_handler #(
    .BUFFER_WIDTH                               (CAC_UART_CH_BUFFER_WIDTH),
    .SETTINGS_ADDR_WIDTH                        (CAC_UART_CH_SETTINGS_ADDR_WIDTH),
    .SETTINGS_DATA_WIDTH                        (CAC_UART_CH_SETTINGS_DATA_WIDTH)
) 
UART_COMMAND_HANDLER_INSTANTATION
(
    .clk                                        (clk_cac),
    .rstb                                       (rstb_cac),
    .uart_rst                                   (uart_ch_uart_rst),
    .uart_data_out                              (uart_data_out),
    .uart_out_full                              (uart_out_full),
    .uart_out_empty                             (uart_out_empty),
    .uart_out_read                              (uart_out_read),
    .uart_data_in                               (uart_data_in),
    .uart_in_write                              (uart_in_write),
    .uart_in_full                               (uart_in_full),
    .uart_in_empty                              (uart_in_empty),
    .settings_addr                              (settings_addr),
    .settings_data_in                           (settings_data_in),
    .settings_data_out                          (settings_data_out),
    .settings_write_en                          (settings_wen)
);
// ---


// UART INSTANTATION
// ---
uart #(
    .BAUDRATE                                   (CAC_UART_BAUDRATE),
    .CLK_FREQ                                   (CAC_UART_CLK_FREQ),
    .BITLEN                                     (CAC_UART_BITLEN),
    .BUFFER_WIDTH                               (CAC_UART_BUFFER_WIDTH),
    .BUFFER_LENGTH                              (CAC_UART_BUFFER_LENGTH),
    .ERRORNUM                                   (CAC_UART_ERRORNUM)
)
UART_INSTANTATION
(
    .clk                                        (clk_cac),
    .rstb                                       (rstb_cac && !uart_ch_uart_rst),
    .rx                                         (uart_rx),
    .tx                                         (uart_tx),
    .data_out                                   (uart_data_out),
    .out_full                                   (uart_out_full),
    .out_empty                                  (uart_out_empty),
    .out_read                                   (uart_out_read),
    .data_in                                    (uart_data_in),
    .in_write                                   (uart_in_write),
    .in_full                                    (uart_in_full),
    .in_empty                                   (uart_in_empty),
    .error_rx                                   (uart_error_rx)
);
// ---



// SETTINGS INSTANTATION
// ---
settings #(
    .MEMORY_WIDTH                               (CAC_SETTINGS_MEMORY_WIDTH),
    .ROM_MEMORY_LENGTH                          (CAC_SETTINGS_ROM_MEMORY_LENGTH),
    .RAM_MEMORY_LENGTH                          (CAC_SETTINGS_RAM_MEMORY_LENGTH)
)
SYSTEM_SETTINGS
(
    .clk                                        (clk_cac),
    .rstb                                       (rstb_cac),
    .wen                                        (settings_wen),
    .addr                                       (settings_addr),
    .data_in                                    (settings_data_in),
    .data_out                                   (settings_data_out),
    .rom_data_0                                 (settings_rom_data_0),
    .rom_data_1                                 (settings_rom_data_1),
    .rom_data_2                                 (settings_rom_data_2),
    .rom_data_3                                 (settings_rom_data_3),
    .rom_data_4                                 (settings_rom_data_4),
    .rom_data_5                                 (settings_rom_data_5),
    .rom_data_6                                 (settings_rom_data_6),
    .rom_data_7                                 (settings_rom_data_7),
    .rom_data_8                                 (settings_rom_data_8),
    .rom_data_9                                 (settings_rom_data_9),
    .rom_data_10                                (settings_rom_data_10),
    .rom_data_11                                (settings_rom_data_11),
    .rom_data_12                                (settings_rom_data_12),
    .rom_data_13                                (settings_rom_data_13),
    .rom_data_14                                (settings_rom_data_14),
    .rom_data_15                                (settings_rom_data_15),
    .ram_data_out_0                             (settings_mem_out_0)
);
assign  settings_rom_data_0                     =   {10'd0, uart_error_rx, uart_in_empty, uart_in_full, uart_out_empty, uart_out_full};
assign  settings_rom_data_1                     =   16'h0000; 
assign  settings_rom_data_2                     =   16'h0000; 
assign  settings_rom_data_3                     =   16'h0000; 
assign  settings_rom_data_4                     =   16'h0000; 
assign  settings_rom_data_5                     =   16'h0000; 
assign  settings_rom_data_6                     =   16'h0000; 
assign  settings_rom_data_7                     =   16'h0000; 
assign  settings_rom_data_8                     =   16'h0000; 
assign  settings_rom_data_9                     =   16'h0000; 
assign  settings_rom_data_10                    =   16'h0000; 
assign  settings_rom_data_11                    =   16'h0000; 
assign  settings_rom_data_12                    =   16'h0000; 
assign  settings_rom_data_13                    =   16'h0000; 
assign  settings_rom_data_14                    =   16'h0000; 
assign  settings_rom_data_15                    =   16'h0000; 
// ---

// DEBUG
// ---
always @(*) 
begin
    case (debug_switch)
        3'd0:
        begin
            debug_leds = uart_data_out;
        end
        3'd1:
        begin
            debug_leds = settings_addr;
        end
        3'd2:
        begin
            debug_leds = settings_data_in;
        end
        3'd3:
        begin
            debug_leds = settings_data_out;
        end
        3'd4:
        begin
            debug_leds = settings_rom_data_0;
        end
        3'd5:
        begin
            debug_leds = uart_data_in;
        end
        3'd6:
        begin
            debug_leds = uart_data_out;
        end
        3'd7:
        begin
            debug_leds = uart_data_out;
        end
        default:
        begin
            debug_leds = uart_data_out;
        end 
    endcase    
end
// ---

endmodule