`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2018 09:41:25
// Design Name: 
// Module Name: split_data  (shortened to sd in this module)
// Project Name: Polyphase Filter
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
parameter data_width = 8;                   // number of bits in a datapoint
parameter h_len = 4;                        // total number of filter coefficients
parameter h_len_bits = h_len*data_width;    // total number of bits in the filter
parameter M = 2;                            // decimation count

module split_data(
    input clk,      // can be any clock rate below a certain maximum frequency
    input reset,

    input ethernet_is_ready,            // whether ethernet is ready to send more
    output reg sd_ready_for_more_data,  // whether this module (split data) is ready for
                                        // more data from ethernet + has an output ready
    
    input [h_len_bits - 1:0] hcoef,     // filter coefficients (ordered correctly)
    input [data_width-1:0] data_in,     // data from ethernet (one datapoint at a time)

    output reg [data_width-1:0] data_out    // output filtered data
);

// the filter
wire [15:0] hcoef0, hcoef1;     // coefficients for filt0 and filt1
assign hcoef0 = hcoef[15:0];    // assumes that previously module has ordered the
assign hcoef1 = hcoef[31:16];   // filter coefficients correctly already

// the data
reg [h_len_bits-1:0]data;               // local shifting buffer of the input data
wire [data_width-1:0] data0, data1;     // data to filt0 and filt1
assign data0 = {data[31:24], data[15:8]};
assign data1 = {data[23:16], data[7:0]};

// the filtering modules
// filter filt0(input datain_rdy, input clk, input [15:0]hcoef,
//                input [15:0]data, output reg [15:0]output_data, output reg dataout_rdy);
reg dataout_rdy = 0;    // whether sd is ready to send data to filters

wire filters_ready;     // whether the filters are ready for more data
wire [data_width-1:0] data0_out;
filter filt0(dataout_rdy, clk, hcoef0, data0, data0_out, filters_ready);

wire tmp1; // filters operate in lockstep => only need to check one to see if they're ready
wire [data_width-1:0] data1_out;
filter filt1(dataout_rdy, clk, hcoef1, data1, data1_out, tmp1);

// the loop
reg [M+2:0]state = 0;
always @(posedge clk) begin

    if (ethernet_is_ready && sd_ready_for_more_data && state < M) begin // load up on data
        data <= {data[h_len_bits - data_width - 1:0], data_in}; // x[0] ... x[n] from t=0 to t=n
        state <= state + 1;
        if (state == M - 1) begin
            sd_ready_for_more_data <= 0;
            dataout_rdy <= 1;
        end
    end
    
    else if (filters_ready) begin // if the filters are ready (done filtering)
        data_out <= data0_out + data1_out;  // add the outputs
        sd_ready_for_more_data <= 1; // and signal to the ethernet module that we're done
        state <= 0; // finally, set the state back to 0
    end
    
    else begin
        sd_ready_for_more_data <= 1; // split_data is ready for more data
    end
end

endmodule