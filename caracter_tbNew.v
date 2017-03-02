`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.03.2017 23:44:51
// Design Name: 
// Module Name: caracter_tb
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


module caracter_tb(
    );
     reg reloj;
     reg reset;
     wire [7:0]pala;
     wire [1:0] ch;
     wire [5:0] row;
     reg [9:0] x;
     reg [9:0] y;
     reg [9:0] xold;
     reg videon;

     caracter test(.clk(reloj),.rst(reset),.video_on(videon),.pixel_x(x),.pixel_y(y),.char(ch),.rowad(row),.palabra(pala));
     initial
         begin
             reloj=0;//inicial el clock en cero
             reset=1;//reset en alto al inicio
             videon=1;
             x=300;
             xold=0;
             y=230;
             #10 reset=0; //despues de diez 10ns, el reset se pone en cero, dando inició al funcionamiento
         end
         always
         begin
             #10 reloj=~reloj; //me genera un clk de 100MHz (1/((10)*1ns))=100MHz
             #40 x=x+1;
             if (x>=303 && x<=334)
             begin
                xold=xold+1;
                if (xold<=31)
                begin
                    xold=xold;
                end
                else
                begin
                    y=y+1;
                    xold=0;
                end
             end
             else
             begin
                xold=0;
             end
         end
endmodule
