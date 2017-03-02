`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/02/2017 10:17:49 AM
// Design Name: 
// Module Name: Caracter
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
 input wire [2:0] RGB,
 input wire clk, // reloj para el font
 input wire rst, //reset
 input wire video_on, // indica donde pintar
 input wire [9:0] pixel_x, pixel_y, // posicion coordenadas x, y
 output reg [2:0] rgb_text, // colores del texto
 output wire [1:0] char, // codigo del caracter
 output wire [5:0] rowad, // direccion en la memoria
 output wire font_bit, // bit de salida segun la posicion del font donde se encuentre
 output wire [7:0] palabra // los 8 de por fila que forma el font
);

//parámetros para definir las letras
localparam Iinicio=303; //donde inicia I
localparam Ifinal=310; // donde finaliza I
localparam Sinicio=315; // donde inicia S
localparam Sfinal=322; // donde finaliza S
localparam Ainicio=327; // donde inicia A
localparam Afinal=334; // donde finaliza A
localparam vinicio=232;//inicio del largo
localparam vfinal=248;//final del largo

// signal declaration
wire [5:0] rom_addr;  // 6 bits, la direccion del font en la memoria
reg [1:0] char_addr; // codigo del caracter
reg [3:0] row_addr;  // numero de filas en un patron
wire [2:0] bit_addr;  // numero de columnas en un patron
wire [7:0] font_word; // bits del font
wire text_bit_on; // indica donde pintar
reg red,green,blue;

// instancia de fontROM
fontROM font
(.clk(clk), .addr(rom_addr), .data(font_word));

// font ROM interface
assign bit_addr = pixel_x [2:0]; // se utilizan los 3 bits menos significativos de x
                                // para recorrer las columnas   
// generación del espacio de memoria a leer
always @(pixel_x,pixel_y,rst)
begin
    if (rst)//colocar el código del fondo negro
    begin
        char_addr=2'b00;
    end
    else
    
    begin
    
        if(pixel_y>=vinicio && pixel_y<=vfinal) //delimita el espacio a utilizar en y [232-248]
        begin
        
            if (pixel_x>=Iinicio && pixel_x<=Ifinal) //delimita el espacio a utilizar en x para I[303-310]
            begin
                char_addr=2'b01; 
                row_addr=pixel_y[3:0];
            end
            
            else if (pixel_x>=Sinicio && pixel_x<=Sfinal) //delimita el espacio a utilizar en x para S[315-322]
            begin
                char_addr=2'b10;
                row_addr=pixel_y[3:0];
            end
            
            else if (pixel_x>=Ainicio && pixel_x<=Afinal) //delimita el espacio a utilizar en x para A[327-334]
            begin
                char_addr=2'b11;
                row_addr=pixel_y[3:0];
            end
            
            else //entre cada letra hay un espacio de cuatro pixeles
            begin
                char_addr=2'b00;
                row_addr=pixel_y[3:0];
            end
        end 
        
        else //todo el espacio restante se deja de color de fondo
        begin
            char_addr=2'b00;
            row_addr=pixel_y[3:0];
        end 
    end
end

assign rom_addr = {char_addr , row_addr}; // forma 
assign font_bit=font_word[~bit_addr]; // bit de salida segun el bit en el que se este posicionado

//para la prueba
assign rowad =rom_addr;
assign char=char_addr;
assign palabra=font_word;

//Salidas de color para los pines del VGA

always @*
    if (video_on) // Verifica si se necesita pintar
    begin
        if (text_bit_on) 
        begin
            assign red = RGB[0]; // el primer bit corresponde al rojo
            assign green = RGB[1]; // el segundo bit corresponde al verde
            assign blue = RGB[2]; // el tercer bit corresponde al azul
            assign rgb_text = {red, green, blue}; // se concatenan los 3 colores para formar el rgb de salida
        end
        else
        begin
        
            rgb_text = 3'b000; // black en caso de no necesitar pintar
        end
    end   
    else
    begin
        rgb_text = 3'b000; // black por default
    end

endmodule

