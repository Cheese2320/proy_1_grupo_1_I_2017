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
 //output reg [2:0] rgb_text // colores del texto
 output wire [1:0] char,
 output wire [5:0] rowad,
 output wire [7:0] palabra
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
localparam contfin=15;
// signal declaration
wire [5:0] rom_addr;  // 6 bits, la direccion del font en la memoria
reg [1:0] char_addr; // codigo del caracter
reg [3:0] row_addr;  // numero de filas en un patron
reg [3:0] row_addr1;
wire [2:0] bit_addr;  // numero de columnas en un patron
wire [7:0] font_word; // bits del font
wire font_bit,text_bit_on; // font_bit pixel de salida
reg i;

// instancia de fontROM
fontrom font
(.clk(clk), .addr(rom_addr), .data(font_word));

// font ROM interface
assign bit_addr = pixel_x [2:0]; // se utilizan los 3 bits menos significativos de x
                                // para recorrer las columnas   
// generación del espacio de memoria a leer
always @(pixel_y,rst)
    if (rst)
    begin
        row_addr1=4'h0;
        i=0;
    end
    else
    begin
        if(pixel_y>=vinicio && pixel_y<=vfinal) 
        begin
            if (row_addr1<=contfin && i>0)
            begin
                row_addr1=row_addr1+1;
            end   
            else
            begin
                row_addr1=0;
                i=i+1;
            end
        end
        else
        begin
            row_addr1=row_addr1;
            i=i;
        end
    end
    

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
                row_addr=row_addr1;
            end
            else if (pixel_x>=Sinicio && pixel_x<=Sfinal) //delimita el espacio a utilizar en x para S[315-322]
            begin
                char_addr=2'b10;
                row_addr=row_addr1;
            end
            else if (pixel_x>=Ainicio && pixel_x<=Afinal) //delimita el espacio a utilizar en x para A[327-334]
            begin
                char_addr=2'b11;
                row_addr=row_addr1;
            end
            else //entre cada letra hay un espacio de cuatro pixeles
            begin
                char_addr=2'b00;
                row_addr=row_addr1;
            end
        end 
        else //todo el espacio restante se deja de color de fondo
        begin
            char_addr=2'b00;
            row_addr=row_addr1;
        end 
    end
end
assign rom_addr = {char_addr , row_addr};
assign font_bit=font_word;

//para la prueba
assign rowad =rom_addr;
assign char=char_addr;
assign palabra=font_word;
endmodule
