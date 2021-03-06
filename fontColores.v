`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/26/2017 07:38:06 PM
// Design Name: 
// Module Name: fontCompleto
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


module fontCompleto(
    input wire clk, // reloj para el font
    input wire video_on, // indica donde pintar
    input wire [9:0] pixel_x, pixel_y, // posicion coordenadas x, y
    output font_bit, // bit de salida que se va pintar
    output reg [2:0] rgb_text // colores del texto
);

// signal declaration
    wire [5:0] rom_addr;  // 6 bits, la direccion del font en la memoria
    wire [1:0] char_addr; // codigo del caracter
    wire [3:0] row_addr;  // numero de filas en un patron
    wire [2:0] bit_addr;  // numero de columnas en un patron
    wire [7:0] font_word; // bits del font
    wire text_bit_on; // font_bit pixel de salida

// instancia de fontROM
fontROM font
(.clk(clk), .addr(rom_addr), .data(font_word));

assign char_addr = {pixel_y [4],pixel_x [3]}; // forma el codigo del caracter 
assign row_addr = pixel_y [3:0]; // se utilizan los 3 bits menos significativos de y
                                 // para recorrer las filas
assign rom_addr = {char_addr , row_addr}; // se concatena char_addr y row_addr para ontener la direccion del font
                                          // en memoria
assign bit_addr = pixel_x [2:0]; // se utilizan los 3 bits menos significativos de x
                                 // para recorrer las columnas   
assign font_bit = font_word [bit_addr]; // Asigna el valor del bit que se haya recorrido
                                 // "on" region limited to top-left corner
assign text_bit_on = (pixel_x [9:4]==0 && pixel_y [9:5] ==0) ? 
                                 font_bit : 1'b0;    



                                 
endmodule
