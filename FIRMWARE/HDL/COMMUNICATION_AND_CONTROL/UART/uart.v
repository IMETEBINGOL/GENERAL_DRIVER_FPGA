module uart 
#(
    parameter                       BAUDRATE        = 115200,
    parameter                       CLK_FREQ        = 100_000_000,
    parameter                       BITLEN          = 8,
    parameter                       BUFFER_WIDTH    = 8,
    parameter                       BUFFER_LENGTH   = 16,
    parameter                       ERRORNUM        = 3
) 
(
    input                           clk,
    input                           rstb,
    input                           rx,
    output                          tx,
    output  [BITLEN-1:0]            data_out,
    output                          out_full,
    output                          out_empty,
    input                           out_read,
    input   [BITLEN-1:0]            data_in,
    input                           in_write,
    output                          in_full,
    output                          in_empty,
    output  [$clog2(ERRORNUM)-1:0]  error_rx
);




// UART TX
wire                                buffer_empty_tx;
wire                                buffer_full_tx;
wire                                busy_tx;
wire    [BITLEN-1:0]                data_tx;
// ---
circular_buffer #(
    .BUFFER_WIDTH                   (BUFFER_WIDTH),
    .BUFFER_LENGTH                  (BUFFER_LENGTH)
)
CIRCULAR_BUFFER_UART_TX_INSTANTATION
(
    .clk                            (clk),
    .rstb                           (rstb),
    .wrt                            (in_write),
    .rd                             (!buffer_empty_tx && !busy_tx),
    .data_in                        (data_in),
    .data_out                       (data_tx),
    .buffer_full                    (buffer_full_tx),
    .buffer_empty                   (buffer_empty_tx)
);

uart_tx #(
    .BAUDRATE                       (BAUDRATE),
    .CLK_FREQ                       (CLK_FREQ),
    .BITLEN                         (BITLEN)
) 
UART_TX_INSTANTATION
(
    .clk                            (clk),
    .rstb                           (rstb),
    .data                           (data_tx),
    .data_ready                     (!busy_tx && !buffer_empty_tx),
    .tx                             (tx),
    .busy                           (busy_tx)
);
// ---




// UART RX
wire buffer_empty_rx;
wire buffer_full_rx;
wire data_ready;
wire [BITLEN-1:0] data_rx;
// ---
circular_buffer #(
    .BUFFER_WIDTH                   (BUFFER_WIDTH),
    .BUFFER_LENGTH                  (BUFFER_LENGTH)
) 
CIRCULAR_BUFFER_UART_RX_INSTANTATION
(
    .clk                            (clk),
    .rstb                           (rstb),
    .wrt                            (data_ready && !buffer_full_rx),
    .rd                             (out_read),
    .data_in                        (data_rx),
    .data_out                       (data_out),
    .buffer_full                    (buffer_full_rx),
    .buffer_empty                   (buffer_empty_rx)
);

uart_rx #(
    .BAUDRATE                       (BAUDRATE),
    .CLK_FREQ                       (CLK_FREQ),
    .BITLEN                         (BITLEN),
    .ERRORNUM                       (ERRORNUM)
) 
UART_RX_INSTANTATION
(
    .clk                            (clk),
    .rstb                           (rstb),
    .rx                             (rx),
    .data_out                       (data_rx),
    .data_ready                     (data_ready),
    .error                          (error_rx)
);
// ---

// PORT ASSIGMENT 
// ---
assign out_full                     = buffer_full_rx;
assign out_empty                    = buffer_empty_rx;
assign in_empty                     = buffer_empty_tx;
assign in_full                      = buffer_full_tx;
// ---
endmodule