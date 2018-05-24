`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2018 08:49:26
// Design Name: 
// Module Name: filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module filter(
    input datain_rdy,
    input clk,
    input [15:0]hcoef,
    input [15:0]data,
    output reg [15:0]output_data,
    output reg dataout_rdy
    );
    
reg     signed      [15:0]  temp_data1;
reg     signed      [15:0]  temp_data2;
reg     signed      [7:0]   h1, h2, x1, x2;
 
always @(posedge clk) begin
if (datain_rdy)
    begin
        //data is pulled in to local registers
        x1 <= data[15:8];
        x2 <= data[7:0];
        h1 <= hcoef[15:8];
        h2 <= hcoef[7:0];
        
        // data points are filtered with specific tap
        temp_data1 = x1*h1;
        temp_data2 = x2*h2;
       // The filtered points are summed
        output_data = temp_data1 + temp_data2;
        
        dataout_rdy <= 1;
    end else dataout_rdy <= 0;
end


endmodule
