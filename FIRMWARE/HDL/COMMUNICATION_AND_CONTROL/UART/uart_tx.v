// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE IS A RECEIVER MODULE FOR UART
// 
// ---

module uart_tx 
#(
    parameter                   BAUDRATE    = 115200,
    parameter                   CLK_FREQ    = 100_000_000,
    parameter                   BITLEN      = 8
) 
(
    input                       clk,
    input                       rstb,
    input       [BITLEN-1:0]    data,
    input                       data_ready,
    output reg                  tx,
    output reg                  busy
);


// LOCAL PARAMETER 
// ---
localparam  HIGH        = 1'b1;
localparam  LOW         = 1'b0;
localparam  DRST        = 32'b0;
localparam  BITCYCLE    = CLK_FREQ/BAUDRATE;
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
reg     [BITLEN-1:0]            data_reg;    
// ---



// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        state                   <= IDLE;
        count                   <= DRST;
        index                   <= DRST;
        tx                      <= HIGH;
        busy                    <= LOW;
        data_reg                <= DRST;
    end
    else
    begin
        case (state)
            IDLE:
            begin
                count           <= DRST;
                index           <= DRST;
                busy            <= LOW;
                tx              <= HIGH;
                data_reg        <= DRST;
                if (data_ready)
                begin
                   busy         <= HIGH;
                   state        <= START;
                end
            end 
            START:
            begin
                tx              <= LOW;
                count           <= count + 1;
                if (count == BITCYCLE - 1)
                begin
                    count       <= DRST;
                    state       <= DATA;
                    data_reg    <= data; 
                end
            end
            DATA:
            begin
                count           <= count + 1;
                tx              <= data_reg[BITLEN-1];
                if (count == BITCYCLE -1)
                begin
                    data_reg    <= {data_reg[BITLEN-2:0], LOW};
                    count       <= DRST;
                    index       <= index + 1;
                    if (index == BITLEN - 1)
                    begin
                        state   <= STOP;
                        index   <= DRST; 
                    end
                end
            end
            STOP:
            begin
                tx              <= HIGH;
                count           <= count + 1;
                if (count == BITCYCLE-1)
                begin
                    count       <= DRST;
                    state       <= IDLE;
                end
            end
            default:
            begin
                state       <= IDLE;
            end 
        endcase
    end
end
// ---
    
endmodule