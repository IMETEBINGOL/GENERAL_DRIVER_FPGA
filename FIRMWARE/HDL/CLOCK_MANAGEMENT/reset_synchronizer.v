// ---
// ENGs: IBRAHIM METE BINGOL
// PROJECT: CAMMP_TECH
// MODULE: THIS MODULE SYNCHRONIZE RESET AND CLOCK GENERATED. 
// 
// ---
module reset_synchronizer 
(
    input       clk,
    input       rstb_in,
    output reg  rstb_out
);
    
// LOCAL PARAMETER 
// ---
localparam  LOW     = 1'b0;
localparam  HIGH    = 1'b1;
// ---


// LOGICAL DESIGN 
// ---
always @(posedge clk or negedge rstb_in) 
begin
    if (!rstb_in) 
    begin
        rstb_out    <=  LOW;
    end
    else
    begin
        rstb_out    <= rstb_in;
    end
end
// ---
endmodule