`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.02.2017 10:12:21
// Design Name: 
// Module Name: caracter
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



module caracter(
 input wire clk, // reloj para el font
 input wire rst, //reset
 input wire video_on, // indica donde pintar
 input wire [9:0] pixel_x, pixel_y, // posicion coordenadas x, y
 input wire R,
 input wire G,
 input wire B,
 output wire r, // colores del texto
 output wire g,
 output wire b,
 output wire [1:0] char,
 output wire [5:0] rowad,
 output wire [7:0] palabra,
 output wire palabit,
 output wire [2:0] posicion
);

//parámetros para definir las letras
localparam Iinicio=303; //donde inicia I
localparam Ifinal=311; // donde finaliza I
localparam Sinicio=319; // donde inicia S
localparam Sfinal=327; // donde finaliza S
localparam Ainicio=335; // donde inicia A
localparam Afinal=343; // donde finaliza A
localparam vinicio=232;//inicio del largo
localparam vfinal=247;//final del largo
// signal declaration
reg [5:0] rom_addr;  // 6 bits, la direccion del font en la memoria
reg [1:0] char_addr; // codigo del caracter
reg [3:0] row_addr;  // numero de filas en un patron
wire [2:0] bit_addr;  // numero de columnas en un patron
wire [7:0] font_word; // bits del font
wire [7:0]font_bit;
wire text_bit_on; // font_bit pixel de salida
reg red,green,blue;

// instancia de fontROM
fontrom font
(.clk(clk), .addr(rom_addr), .data(font_word));

// font ROM interface
assign bit_addr = pixel_x [2:0]; // se utilizan los 3 bits menos significativos de x
                                // para recorrer las columnas   
// generación del espacio de memoria a leer
always @(pixel_x,rst)
begin
    if (rst)//colocar el código del fondo negro
    begin
        char_addr=2'b00;
    end
    else
    begin
        if(pixel_y>=vinicio && pixel_y<=vfinal) //delimita el espacio a utilizar en y [232-248]
        begin
            if (pixel_x>Iinicio && pixel_x<=Ifinal) //delimita el espacio a utilizar en x para I[304-311]
            begin
                char_addr=2'b01;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
            else if (pixel_x>Sinicio && pixel_x<=Sfinal) //delimita el espacio a utilizar en x para S[316-323]
            begin
                char_addr=2'b10;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
            else if (pixel_x>Ainicio && pixel_x<=Afinal) //delimita el espacio a utilizar en x para A[328-335]
            begin
                char_addr=2'b11;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
            else //entre cada letra hay un espacio de cuatro pixeles
            begin
                char_addr=2'b00;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
        end 
        else //todo el espacio restante se deja de color de fondo
        begin
            char_addr=2'b00;
            row_addr={~pixel_y [3],pixel_y[2:0]};
            rom_addr = {char_addr , row_addr};
        end 
    end
end

assign bit_addr= pixel_x[2:0];
assign font_bit=font_word [~bit_addr];

always @(R,G,B,video_on,font_bit)
    if (video_on) // Verifica si se necesita pintar
    begin
        if (font_bit==1) 
        begin
            red = R; // el primer bit corresponde al rojo
            green = G; // el segundo bit corresponde al verde
            blue = B; // el tercer bit corresponde al azul
        end
        else
        begin
            red = 0; // el primer bit corresponde al rojo
            green = 0; // el segundo bit corresponde al verde
            blue = 0; // el tercer bit corresponde al azul 
        end
    end   
    else
    begin
        red = 0; // el primer bit corresponde al rojo
        green = 0; // el segundo bit corresponde al verde
        blue = 0; // el tercer bit corresponde al azul 
    end
//para la prueba
assign rowad =rom_addr;
assign char=char_addr;
assign palabra=font_word;
assign palabit=font_bit;
assign r = red; // el primer bit corresponde al rojo
assign g = green; // el segundo bit corresponde al verde
assign b = blue; // el tercer bit corresponde al azul 
assign posicion=~bit_addr;
endmodule
