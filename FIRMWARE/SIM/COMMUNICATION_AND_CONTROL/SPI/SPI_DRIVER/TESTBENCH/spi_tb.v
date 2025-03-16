`timescale 1ns/1ps
module spi_tb
(

);

`include "CLOCK_MANAGEMENT_PARAMETER.vh"
`include "COMMUNICATION_AND_CONTROL_PARAMETER.vh"


// LOCAL PARAMETER
// ---
localparam  HIGH                    = 1'b1;
localparam  LOW                     = 1'b0;
localparam  DRST                    = 32'd0;
localparam  SECOND_IN_NANOSECOND    = 1_000_000_000;
localparam  CLK_PERIOD              = SECOND_IN_NANOSECOND/CAC_CLK_FREQUENCY;
// ---

// CLOCK GENERATION
wire        clk;
// ---
clock_generation_sim #(
    .CLK_1_FREQUENCY(CAC_CLK_FREQUENCY),
    .CLK_1_INITIALIZING_DELAY(0),
    .CLK_1_PHASE(0)
) 
CLOCK_GENERATION
(
    .clk_out_1(clk)
);
// ---

// RESET GENERATION 
reg     rstb    = HIGH;
// ---
initial
begin
    rstb        = LOW;
    #(10*CLK_PERIOD);
    rstb        = HIGH;
end
// ---

// UUT INSTANTATION
reg                                         sdi;
reg                                         rw_op;
reg [CAC_SPI_PACKAGE_WIDTH-2:0]             addr_in;
reg [CAC_SPI_PACKAGE_WIDTH-1:0]             data_in;
reg                                         send;
wire                                        csb;
wire                                        sdo;
wire                                        busy;
wire                                        data_ready;
wire [CAC_SPI_PACKAGE_WIDTH-1:0]            data_out;
// ---
spi #(
    .PACKAGE_SIZE(CAC_SPI_PACKAGE_WIDTH)
) 
UUT
(
    .clk                                    (clk),
    .rstb                                   (rstb),
    .sdi                                    (sdi),
    .csb                                    (csb),
    .sdo                                    (sdo),
    .rw_op                                  (rw_op),
    .addr_in                                (addr_in),
    .data_in                                (data_in),
    .send                                   (send),
    .busy                                   (busy),
    .data_ready                             (data_ready),
    .data_out                               (data_out)
);
// ---

initial
begin
    rw_op       = LOW;
    addr_in     = DRST;
    data_in     = DRST;
    send        = LOW;
    sdi         = LOW;
    #(CLK_PERIOD*100);
    while(busy)
    begin
        #(CLK_PERIOD);
    end
    rw_op       = LOW;
    addr_in     = 7'h24;
    data_in     = 8'hCC;
    send        = HIGH;
    #(CLK_PERIOD*2);
    send        = LOW;
    @(negedge busy);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    while(busy)
    begin
        #(CLK_PERIOD);
    end
    rw_op       = HIGH;
    addr_in     = 7'h28;
    send        = HIGH;
    @(posedge clk);
    send        = LOW;  
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    @(posedge clk);
    sdi        = HIGH;
    @(posedge data_ready);
    sdi        = LOW;
    if (data_out == 8'h0F)
    begin
        $display("TEST PASSED: data_out = %h", data_out);
    end
    $finish;
end
endmodule