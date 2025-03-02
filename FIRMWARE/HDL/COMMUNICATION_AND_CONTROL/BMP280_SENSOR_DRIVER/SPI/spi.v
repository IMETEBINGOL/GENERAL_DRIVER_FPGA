module moduleName 
#(
    parameter               PACKAGE_SIZE    = 8
) 
(
    input                           clk,
    input                           rstb,
    input                           sdi,
    output  reg                     csb,
    output  reg                     sdo,
    input                           rw_op,
    input   [PACKAGE_SIZE-2:0]      addr_in,
    input   [PACKAGE_SIZE-1:0]      data_in,
    input                           send,
    output                          busy,
    output  reg                     data_ready,
    output  [PACKAGE_SIZE-1:0]      data_out
);

// LOCAL PARAMETER 
// ---
localparam                              HIGH        = 1'b1;
localparam                              LOW         = 1'b0;
localparam                              DRST        = 32'd0;
// ---

// STATES 
// ---""
localparam                              IDLE        = 0;
localparam                              RWADDR      = 1;
localparam                              WRITE       = 2;
localparam                              READ        = 3;
localparam                              NUMSTATE    = 4;
localparam                              IDLE_READ   = 0;
localparam                              READ_READ   = 1;
localparam                              NUMREAD     = 2;
// ---


// LOCAL VARIABLE 
// ---
reg     [$clog2(NUMSTATE)-1:0]          state;
reg     [$clog2(NUMREAD)-1:0]           state_read;
reg     [PACKAGE_SIZE-1:0]              addr;
reg     [PACKAGE_SIZE-1:0]              data;
reg     [PACKAGE_SIZE-1:0]              data_read;
reg     [$clog2(PACKAGE_SIZE)-1:0]      counter;
// ---


// WRITE SPI
// ---
always @(negedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        state                           <= IDLE;
        addr                            <= DRST;
        data                            <= DRST;
        csb                             <= HIGH;
        sdo                             <= HIGH;
        counter                         <= DRST;
    end
    else
    begin
        case (state)
            IDLE:
            begin
                csb                     <= HIGH;
                if (send)
                begin
                    state               <= RWADDR;
                    addr                <= {rw_op, addr_in};
                    data                <= data_in;
                    csb                 <= LOW;
                end
            end 
            RWADDR:
            begin
                sdo                     <= addr[PACKAGE_SIZE-1];
                addr                    <= {addr[PACKAGE_SIZE-2:0], LOW};
                counter                 <= counter + 1;
                if (counter == PACKAGE_SIZE-1)
                begin
                    state               <= rw_op ? READ : WRITE;
                end
            end             
            WRITE:
            begin
                sdo                     <= data[PACKAGE_SIZE-1];
                data                    <= {data[PACKAGE_SIZE-2:0], LOW};
                counter                 <= counter + 1;
                if (counter == PACKAGE_SIZE-1)
                begin
                    state               <= IDLE;
                end
            end
            READ:
            begin
                counter                 <= counter + 1;
                if (counter == PACKAGE_SIZE-1)
                begin
                    state               <= IDLE;
                end
            end                    
            default:
            begin
                state                   <= IDLE;
            end 
        endcase
    end
end
// ----


// READ SPI
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        data_ready                      <= LOW;
        state_read                      <= IDLE_READ;
        data_read                       <= DRST;
    end
    else
    begin
        case (state_read)
            IDLE_READ:
            begin
                data_ready              <= HIGH;
                if (state == READ)
                begin
                    data_ready          <= LOW;
                    data_read[0]        <= sdi;
                    state_read          <= READ_READ;
                end 
            end 
            READ_READ:
            begin
                data_read               <= {data_read[PACKAGE_SIZE-2:0], sdi};
                if (state != READ)
                begin
                    state_read          <= IDLE_READ;
                end
            end
            default:
            begin
                state_read              <=  IDLE_READ;
            end 
        endcase
    end
end
// ---
// PORT ASSIGMENT 
// ---
assign busy                 = (state != IDLE);
// ---    
endmodule