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
    // variables que se van a utilizar
    reg reloj;
    reg reset;
    wire hori;
    wire verti;
    //wire [5:0] row;
    //wire [2:0] po;
    reg rojo; 
    reg verde;
    reg azul;
    wire red;
    wire green;
    wire blue;
    //instaciamiento del módulo 
    VGA vga(.clk(reloj),
            .reset(reset),
            .h_sync(hori),
            .v_sync(verti),
            .red(rojo),
            .green(verde),
            .blue(azul),
            .Red(red),
            .Green(green),
            .Blue(blue));
    initial
    begin
        reloj=0;//inicial el clock en cero
        reset=1;
        rojo=1; //simula el switch de rojo en 1
        verde=1; //simula el switch de verde en 1
        azul=0; //simula el switch de azul en 0
        #10 reset=0;  //despues de diez 10ns, el reset se pone en cero, dando inició al funcionamiento
     end
     always
     begin
        #10 reloj=~reloj; //me genera un clk de 100MHz (1/((10)*1ns))=100MHz
     end
endmodule
