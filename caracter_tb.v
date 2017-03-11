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
    // inicialización de variables
     reg reloj;
     reg reset;
     //wire [7:0]pala;
     //wire [1:0] ch;
     //wire [5:0] row;
     reg [9:0] x;
     reg [9:0] y;
     reg videon;
     reg rojo;
     reg verde;
     reg azul;
     wire red;
     wire green;
     wire blue;
     //wire bitpa;
     //wire [2:0]pospa;
     //instaciamieno del módulo caracter para su funcionamiento. 
     caracter test(.clk(reloj),
                   .rst(reset),
                   .video_on(videon),
                   .pixel_x(x),
                   .pixel_y(y),
                   .R(rojo),
                   .G(verde),
                   .B(azul),
                   .r(red),
                   .g(green),
                   .b(blue));
     //condiciones de simulación
     initial
         begin //lo que se escribe desde este begin hasta el end antes del always se ejecuta una unica vez en la simulación
             reloj=0;//inicial el clock en cero
             reset=1;//reset en alto al inicio
             rojo=0; //rojo, verde, azul simulan las entradas, como si fuesen los switches
             verde=0;
             azul=0;
             videon=1; //simula la señal de habilitación video_on en el módulo
             x=302; //simula a pixel x en este módulo
             y=233; //simula a pixel y en este módulo
             #10 reset=0; //despues de diez 10ns, el reset se pone en cero, dando inició al funcionamiento
         end
         always // hace que esta función que las siguientes variables esten cambiando, para simular el clock, la señal de video, switches, etc..
         begin
             #10 reloj=~reloj; //me genera un clk de 100MHz (1/((10)*1ns))=100MHz
             #10 x=x+1; //solo se modifica el pixel x (solo se esta leyendo una fila en y, para facilidad de simulación
             #100 videon=~videon;
             #15 rojo=~rojo;
             #20 verde=~verde;
             #25 azul=~azul;
         end                                                                       
endmodule
