`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 08:38:45
// Design Name: 
// Module Name: VGA_tb
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


module VGA_tb(
    );
    reg reloj;
    reg reset;
    wire hori;
    wire verti;
    wire [9:0]x;
    wire [9:0]y;
    wire [5:0] row;
    wire [2:0] po;
    wire vid;
    reg rojo; 
    reg verde;
    reg azul;
    wire red;
    wire green;
    wire blue;
    
    VGA vga(.clock(reloj),
            .reset(reset),
            .h_sync(hori),
            .v_sync(verti),
            .red(rojo),
            .green(verde),
            .blue(azul),
            .Red(red),
            .Green(green),
            .Blue(blue),
            .px(x),
            .py(y),
            .rowad1(row),
            .pos(po),
            .video(vid));
    initial
    begin
        reloj=0;//inicial el clock en cero
        reset=1;
        rojo=0;
        verde=1;
        azul=0;
        #10 reset=0;
        //despues de diez 10ns, el reset se pone en cero, dando inició al funcionamiento
     end
     always
     begin
        #10 reloj=~reloj; //me genera un clk de 100MHz (1/((10)*1ns))=100MHz
     end
endmodule
