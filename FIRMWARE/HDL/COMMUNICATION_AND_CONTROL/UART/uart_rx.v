// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE IS A RECEIVER MODULE FOR UART
// 
// ---

module uart_rx 
#(
    parameter                               BAUDRATE    = 115200,
    parameter                               CLK_FREQ    = 100_000_000,
    parameter                               BITLEN      = 8,
    parameter                               ERRORNUM    = 3
) 
(
    input                                   clk,
    input                                   rstb,
    input                                   rx,
    output reg  [BITLEN-1:0]                data_out,
    output reg                              data_ready,
    output reg  [$clog2(ERRORNUM)-1:0]      error
);

// LOCAL PARAMETER 
// ---
localparam  HIGH        = 1'b1;
localparam  LOW         = 1'b0;
localparam  DRST        = 32'b0;
localparam  BITCYCLE    = CLK_FREQ/BAUDRATE;
localparam  NOERROR     = 0;
localparam  STARTERROR  = 1;
localparam  STOPERROR   = 2;
// ---


// STATES 
// ---
localparam  IDLE        = 0;
localparam  START       = 1;
localparam  DATA        = 2;
localparam  STOP        = 3;
localparam  NUMSTATE    = 4;
// ---






// LOCAL VARIABLE 
// ---
reg     [$clog2(NUMSTATE)-1:0]  state;
reg     [$clog2(BITCYCLE)-1:0]  count;
reg     [$clog2(BITLEN)-1:0]    index; 
// ---


// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        state                       <= IDLE;
        count                       <= DRST;
        index                       <= DRST;
        data_out                    <= DRST;
        error                       <= NOERROR;
        data_ready                  <= LOW;
    end
    else
    begin
        data_ready                  <= LOW;
        case (state)
            IDLE:
            begin
                state               <= rx ? IDLE : START; 
                data_out            <= DRST;
                count               <= DRST;
                index               <= DRST;
            end
            START:
            begin
                count               <= count + 1;
                if (count == BITCYCLE/2)
                begin
                    if (rx)
                    begin
                        state       <= IDLE;
                        error       <= STARTERROR;
                    end
                    else
                    begin
                        state       <= DATA;
                        error       <= NOERROR;
                    end
                    count           <= DRST;
                end
            end
            DATA:
            begin
                count               <= count + 1;
                if (count == BITCYCLE)
                begin
                    index           <= index + 1;
                    if (index == BITLEN - 1)
                    begin
                        state       <= STOP;
                        index       <= DRST;
                    end
                    count           <= DRST;
                    data_out        <= {data_out[BITLEN-2:0], rx};
                end
            end
            STOP:
            begin
                count               <= count + 1;
                if (count == BITCYCLE)
                begin
                    state           <= IDLE;
                    if (rx)
                    begin
                        error       <= NOERROR;
                        data_ready  <= HIGH;
                    end
                    else
                    begin
                        error       <= STOPERROR;
                    end
                end                
            end 
            default:
            begin
                state               <= IDLE;
                error               <= NOERROR;
            end 
        endcase
    end
end
// ---






endmodule