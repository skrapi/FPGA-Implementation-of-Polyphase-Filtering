`timescale 1ns / 1ps

module Main(
input CLK100MHZ,
input CPU_RESETN,
//input BTNC,
output LED,
output [4:1]JA
   );
wire [11:0] counter1;

wire clk_div;
wire clk_div2;
wire clk_div3;



    clock_divider #(
        .max_count(300000)
    ) clk_div1er (
        .clk(CLK100MHZ), 
        .rst(CPU_RESETN), 
        .clk_div(clk_div)
    );
    
    clock_divider #(
        .max_count(1)
    )clk_div2er(
        .clk(CLK100MHZ), 
        .rst(CPU_RESETN), 
        .clk_div(clk_div2)
    );
    
    clock_divider #(
        .max_count(100)
    )clk_div3er(
        .clk(CLK100MHZ), 
        .rst(CPU_RESETN), 
        .clk_div(clk_div3)
    );

up_down_counter counter2 (
    .clk(clk_div), 
    .counter(counter1)
    );


DA2RefComp refComp1 (
    .CLK(clk_div2), 
    .RST(CPU_RESETN), 
    .D1(JA[2]), 
    .D2(JA[3]), 
    .CLK_OUT(JA[4]), 
    .nSYNC(JA[1]), 
    .DATA1(12'b11111111111), 
    .DATA2(counter1), 
    .START(clk_div3), 
    .DONE(LED)
    );



endmodule
