`include "MODULES/command_opcodes.vh"
`include "MODULES/command_parameter.vh"
module spi_command_handler 
#(
    parameter                           PACKAGE_SIZE   = 8
) 
(
    // CONTROL OF MODULE 
    input                               clk,
    input                               rstb,
    input   [PACKAGE_SIZE-1:0]          cmd,
    input   [PACKAGE_SIZE-1:0]          data_in,
    input   [PACKAGE_SIZE-1:0]          addr_in,
    input                               exec,
    output                              busy,
    output  [PACKAGE_SIZE-1:0]          data_out,
    // SPI INTERFACE    
    input                               sdi,
    output                              csb,
    output                              sdo
);


// TASK OF MODULE
// ---
`include "MODULES/tasks.vh"
// ---

// LOCAL PARAMETER
// ---
localparam                              HIGH        = 1'b1;
localparam                              LOW         = 1'b0;
localparam                              DRST        = 32'd0;   
// ---

// STATE 
// ---
localparam                              CMDREAD     = 0;
localparam                              CMDEXEC     = 1;
localparam                              NUMSTATE    = 2;
// ---



// LOCAL VARIABLE 
// ---
reg     [clog2(NUMSTATE)-1:0]           state;
reg     [PACKAGE_SIZE-1:0]              cmd_spi;
reg     [4*PACKAGE_SIZE-1:0]            data_spi;
reg     [PACKAGE_SIZE-2:0]              addr_spi;
reg     [7:0]                           cmd_state;
wire                                    spi_busy;
wire                                    spi_data_ready;
wire    [PACKAGE_SIZE-1:0]              spi_data_out;
reg                                     spi_send;
reg     [PACKAGE_SIZE-1:0]              spi_data;
reg     [PACKAGE_SIZE-2:0]              spi_addr;
reg                                     spi_rw_op
reg     [PACKAGE_SIZE-1:0]              data_return;
// ---



// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb) 
begin

    if (!rstb)
    begin
        state                       <= DRST;
        cmd_spi                     <= DRST;
        data_spi                    <= DRST;
        addr_spi                    <= DRST;
        spi_addr                    <= DRST;
        spi_data                    <= DRST;
        data_return                 <= DRST;
        spi_send                    <= LOW;
        spi_rw_op                   <= LOW;
        cmd_state                   <= COMMAND_STATE_INITIAL;
    end
    else
    begin
        spi_send                    <= LOW;
        case (state)
            CMDREAD:
            begin
                if (exec)
                begin
                    cmd_spi         <= cmd;
                    data_spi        <= data;
                    state           <= CMDEXEC;
                    cmd_state       <= COMMAND_STATE_INITIAL;
                end
            end
            CMDEXEC:
            begin
                `include "MODULES/command_compiler.vh"
            end
            default:
            begin
               state                <= CMDREAD; 
            end 
        endcase
    end
end
// --

// SPI INSTANTATION
// ---
spi #(
    .PACKAGE_SIZE                   (PACKAGE_SIZE)
) 
SPI_INSTANTATION 
(
    .clk                            (clk),
    .rstb                           (rstb),
    .sdi                            (sdi),
    .csb                            (csb),
    .sdo                            (sdo),
    .rw_op                          (spi_rw_op),
    .addr_in                        (spi_addr),
    .data_in                        (spi_data),
    .send                           (spi_send),
    .busy                           (spi_busy),
    .data_ready                     (spi_data_ready),
    .data_out                       (spi_data_out)
);
// ---


// PORT ASSIGMENT 
// ---
assign busy                         = (state != CMDREAD);
// ---
// END OF MODULE 
endmodule