`include "MODULES/command_opcodes.vh"
`include "MODULES/command_parameter.vh"
module uart_command_handler
#(
    parameter       BUFFER_WIDTH            = 8,
    parameter       SETTINGS_ADDR_WIDTH     = 8,
    parameter       SETTINGS_DATA_WIDTH     = 16
) 
(
    // CLOCK AND RESET
    input                                   clk,
    input                                   rstb,
    // CONTROL SIGNALS 
    output reg                              uart_rst,
    // UART PORTS
    input       [BUFFER_WIDTH-1:0]          uart_data_out,
    input                                   uart_out_full,
    input                                   uart_out_empty,
    output reg                              uart_out_read,
    output reg  [BUFFER_WIDTH-1:0]          uart_data_in,
    output reg                              uart_in_write,
    input                                   uart_in_full,
    input                                   uart_in_empty,
    // SETTINGS CONTROL SIGNAL          
    output reg  [SETTINGS_ADDR_WIDTH-1:0]   settings_addr,
    output reg  [SETTINGS_DATA_WIDTH-1:0]   settings_data_in,
    input       [SETTINGS_DATA_WIDTH-1:0]   settings_data_out,
    output reg                              settings_write_en
);

// TASK OF SYSTEM
// ---
`include "MODULES/command_task.vh"
// ---

// LOCAL PARAMETER 
// ---
localparam  HIGH                = 1'b1;
localparam  LOW                 = 1'b0;
localparam  DRST                = 32'd0;
// ---

// STATES 
// ---
localparam  IDLE                = 0;
localparam  CMDREAD             = 1;
localparam  CMDWAIT             = 2;
localparam  CMDDECODE           = 3;
localparam  CMDEXEC             = 4;
localparam  NUMSTATE            = 5;
// ---

// LOCAL VARIABLE 
// ---
reg [$clog2(NUMSTATE)-1:0]      state;
reg [BUFFER_WIDTH-1:0]          command;
reg [3:0]                       command_state;
// ---


always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        state                   <= IDLE;
        command                 <= DRST;
        command_state           <= DRST;
        uart_out_read           <= LOW;
        uart_in_write           <= LOW;
        uart_rst                <= LOW;
        uart_data_in            <= DRST;
        settings_write_en       <= LOW;
        settings_addr           <= DRST;
        settings_data_in        <= DRST;
    end
    else
    begin
        uart_out_read           <= LOW;
        uart_in_write           <= LOW;
        settings_write_en       <= LOW;
        case (state)
            IDLE:
            begin
                state           <= uart_out_empty ? IDLE: CMDREAD;             
            end
            CMDREAD:
            begin
                state           <= CMDWAIT;
                uart_out_read   <= uart_out_full ? LOW : HIGH;
            end
            CMDWAIT:
            begin
                state           <= CMDDECODE;
            end
            CMDDECODE:
            begin
                command         <= uart_out_full ? `UARTRST_OPCODE : uart_data_out;
                goto(COMMAND_INITIAL_STATE);
                state           <= CMDEXEC;
            end
            CMDEXEC:
            begin
                `include "MODULES/command_compiler.vh"
            end
            default:
            begin
                state           <= IDLE;
            end 
        endcase
    end
end  
endmodule