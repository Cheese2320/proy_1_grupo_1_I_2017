`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2017 21:03:29
// Design Name: 
// Module Name: divisor_tb
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

//la explicación de este testbench es la misma que para el sincronizador_tb, solo cambian las variables utilizadas y el módulo simulado
module divisor_tb(
    );
     reg reloj;
     reg reset; 
     wire fre;
     div test(.clk(reloj),.reset(reset),.clk_out(fre));
       initial
       begin
           reloj=0;
           reset=1;
           #10 reset=0;
       end
       always
       begin
           #10 reloj=~reloj;
       end
endmodule
