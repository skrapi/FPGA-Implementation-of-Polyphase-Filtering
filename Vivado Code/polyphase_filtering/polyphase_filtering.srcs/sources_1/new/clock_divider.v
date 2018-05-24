`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:46:06 06/23/2015 
// Design Name: 
// Module Name:    clock_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock_divider #(
    parameter max_count = 10
)
(
    input clk,
    input rst,
    output reg clk_div
    );

reg [31:0] count;
 
always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1'b1)
        count <= 32'b0;
    else if (count == max_count - 1)
        count <= 32'b0;
    else
        count <= count + 1;
			  
end


always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1'b1)
        clk_div <= 1'b0;
    else if (count == max_count - 1)
        clk_div <= ~clk_div;
    else
        clk_div <= clk_div;
end


endmodule
