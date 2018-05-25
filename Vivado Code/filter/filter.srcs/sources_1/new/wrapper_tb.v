`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2018 08:49:26
// Design Name: 
// Module Name: wrapper_tb
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

module wrapper_tb();

    reg             clk;
    reg             reset;
    reg     [31:0]  hcoef;
    reg             input_data_ready;
    wire            ready_for_more_data;
    reg     [7:0]   data_in;
    wire    [7:0]   dout;
    
    
    spilt_data split_data_0(
        clk,
        reset,
    
        input_data_ready, // ethernet is ready to send more
        ready_for_more_data, // this module is ready for more data from ethernet
        
        hcoef, // filter coefficients
        data_in, // data from ethernet (one byte at a time)
        
        dout // output filtered data
    );
    
    initial begin
    clk = 0;
    reset = 0;
    data_in = 5;
    hcoef = 32'h01_01_01_01;
    input_data_ready = 1;
    end


endmodule
