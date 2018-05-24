`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.05.2018 16:00:08
// Design Name: 
// Module Name: up_down_counter
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



module up_down_counter(
input clk,
output reg [11:0] counter = 0
    );
	 
reg direction= 0;
	   
   always @(posedge clk)
          if(direction == 0)begin
                counter <= counter + 1;
                if (counter == 12'hBBB) 
                direction <= 1;        
                     
           end
           else if(direction == 1)begin
                  counter <= counter - 1;
                if (counter == 12'h700) 
                 direction <= 0;        
            end      
                           
            
            
endmodule

