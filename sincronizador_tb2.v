`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2017 19:22:33
// Design Name: 
// Module Name: sincronizador_tb
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


module sincronizador_tb(
    ); //variables para inicializar la simulación
    reg reloj;
    reg reset;
    wire hsy;
    wire vsy;
    wire [9:0] x;
    wire [9:0] y;
    wire videon;
    sincronizador test(.clk(reloj),.rst(reset),.hsync(hsy),.vsync(vsy),.vidon(videon),.px(x),.py(y)); //llamó al módulo a simular
    initial
    begin
        reloj=0;//inicial el clock en cero
        reset=1;//reset en alto al inicio
        #10 reset=0; //despues de diez 10ns, el reset se pone en cero, dando inició al funcionamiento
    end
    always
    begin
        #10 reloj=~reloj; //me genera un clk de 100MHz (1/((10)*1ns))=100MHz
    end
endmodule
