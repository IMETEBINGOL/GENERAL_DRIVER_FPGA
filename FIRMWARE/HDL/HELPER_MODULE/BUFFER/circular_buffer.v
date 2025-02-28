// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE CREATE CIRCULAR BUFFER FOR SYSTEM
// BUFFER_LENGTH MUST BE THE POWER OF TWO
// ---
module circular_buffer 
#(
    parameter       BUFFER_WIDTH    = 8,
    parameter       BUFFER_LENGTH   = 16
) 
(
    input                           clk,
    input                           rstb,
    input                           wrt,
    input                           rd,
    input       [BUFFER_WIDTH-1:0]  data_in,
    output reg  [BUFFER_WIDTH-1:0]  data_out,
    output                          buffer_full,
    output                          buffer_empty
);
    

// LOCAL PARAMETER 
// ---
localparam  HIGH    = 1'b1;
localparam  LOW     = 1'b0;
localparam  DRST    = 32'b0;
// ---

// STATE 
// ---
localparam  IDLE            = 0;
localparam  WRITE           = 1;
localparam  READ            = 2;
localparam  WRITEREAD       = 3;
localparam  NUM_OF_STATE    = 4;
// ---

// LOCAL VARIABLE 
// ---
integer i;
reg     [BUFFER_WIDTH-1:0]          buffer [0:BUFFER_LENGTH-1];
reg     [$clog2(BUFFER_LENGTH)-1:0] wr_ptr;
reg     [$clog2(BUFFER_LENGTH)-1:0] rd_ptr;
reg     [$clog2(BUFFER_LENGTH):0]   num_elem;
wire                                full;
wire                                empty;
// ---



// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb) 
begin
    if (!rstb)
    begin
        for (i = 0; i < BUFFER_LENGTH; i = i + 1)
        begin
            buffer[i]   <= DRST;
        end
        wr_ptr      <=  DRST;
        rd_ptr      <=  DRST;
        num_elem    <=  DRST;
        data_out    <=  DRST;
    end
    else
    begin
        case ({rd, wrt})
            IDLE:
            begin
                wr_ptr          <= wr_ptr;
                rd_ptr          <= rd_ptr;
                num_elem        <= num_elem;
            end
            WRITE:
            begin
                wr_ptr          <= wr_ptr + 1;
                buffer[wr_ptr]  <= data_in;
                num_elem        <= num_elem + !full;
            end
            READ:
            begin
                rd_ptr          <= rd_ptr + 1;
                data_out        <= buffer[rd_ptr];
                num_elem        <= num_elem - !empty;
            end 
            WRITEREAD:
            begin
                buffer[wr_ptr]  <= data_in;
                data_out        <= buffer[rd_ptr];
                wr_ptr          <= wr_ptr + 1;
                rd_ptr          <= rd_ptr + 1;
            end
            default:
            begin
                wr_ptr          <= wr_ptr;
                rd_ptr          <= rd_ptr;
                num_elem        <= num_elem; 
            end 
        endcase
    end
end
// ---

assign empty        = (num_elem == 0);
assign full         = (num_elem == BUFFER_LENGTH);
assign buffer_full  = full;
assign buffer_empty = empty;
endmodule