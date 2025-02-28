`timescale 1ns/1ps
module uart_command_handler_tb 
(
);

`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"
`include "UART_COMMAND_OPCODES.vh"

// LOCAL PARAMETER 
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'b0;
localparam  NANOSEC                 = 1_000_000_000;
localparam  SETTINGS_ADDR_WIDTH     = 8;
localparam  SETTINGS_DATA_WIDTH     = 16;
// ---

reg [CAC_BUFFER_WIDTH-1:0]          uart_data_out       = DRST;
reg                                 uart_out_full       = LOW;
reg                                 uart_out_empty      = HIGH;
reg                                 uart_in_full        = LOW;
reg                                 uart_in_empty       = HIGH;
reg [SETTINGS_DATA_WIDTH-1:0]       settings_data_in    = DRST + 16'hC5C5;


// CLOCK GENERATION 
reg clk;
// ---
initial 
begin
    clk = LOW;
    //OFFSET
    #50;
    forever 
    begin
        #50;
        clk = !clk;    
    end    
end
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


// UART_MANAGEMENT
// ---
initial
begin
    #500;
    uart_out_empty  = HIGH;
    #10;
    @(negedge clk);
    uart_out_empty  = LOW;
    @(posedge uart_out_read);
    uart_data_out   = `UARTRST_OPCODE;
    @(posedge uart_out_read);
    uart_data_out   = `WRITEREG_OPCODE;
    @(posedge uart_out_read);
    uart_data_out   = 8'h0F;
    @(posedge uart_out_read);
    uart_data_out   = `READREG_OPCODE;
    @(posedge uart_out_read);
    uart_data_out   = 8'hA0;
    uart_out_empty  = HIGH;
end
// ---


// UUT
wire                                uart_rst;
wire                                uart_out_read;
wire [CAC_BUFFER_WIDTH-1:0]         uart_data_in;
wire                                uart_in_write;
wire [SETTINGS_ADDR_WIDTH-1:0]      settings_addr;
wire [SETTINGS_DATA_WIDTH-1:0]      settings_data_in;
wire                                settings_write_en;

// ---
uart_command_handler #(
    .BUFFER_WIDTH               (CAC_BUFFER_WIDTH)
) 
UUT
(
    .clk                        (clk),
    .rstb                       (rstb),
    .uart_rst                   (uart_rst),
    .uart_data_out              (uart_data_out),
    .uart_out_full              (uart_out_full),
    .uart_out_empty             (uart_out_empty),
    .uart_out_read              (uart_out_read),
    .uart_data_in               (uart_data_in),
    .uart_in_write              (uart_in_write),
    .uart_in_full               (uart_in_full),
    .uart_in_empty              (uart_in_empty),
    .settings_addr              (settings_addr),
    .settings_data_in           (settings_data_in),
    .settings_data_out          (settings_data_in),
    .settings_write_en          (settings_write_en)
);
// ---

endmodule