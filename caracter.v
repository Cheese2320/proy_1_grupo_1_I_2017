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
//inicialización de entradas y salidas
 input wire clk, // reloj para el font
 input wire rst, //reset
 input wire video_on, // indica donde pintar
 input wire [9:0] pixel_x, pixel_y, // posicion coordenadas x, y
 input wire R,
 input wire G,
 input wire B,
 //output wire [5:0] rowad,
 //output wire [2:0] posicion,
 output wire r, // colores del texto
 output wire g,
 output wire b
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
reg [5:0] rom_addr;  // 6 bits, la direccion del font en la memoria; los dos bits más significativos son el código del carácter y los otros cuatro son el número de fila
reg [1:0] char_addr; // codigo del caracter
reg [3:0] row_addr;  // numero de filas en un patron
wire [2:0] bit_addr;  // numero de columnas en un patron
wire [7:0] font_word; // bits del font, o sea, lo que se esta leyendo en memoria
//wire font_bit; //toma el valor del bit que se esta leyendo de cada fila
wire [7:0]font_bit;
reg red,green,blue; //cables auxiales que ayuda a realizar el multiplexado

// instancia de fontROM
fontrom font
(.clk(clk), .addr(rom_addr), .data(font_word));

// font ROM interface
assign bit_addr = pixel_x [2:0]; // se utilizan los 3 bits menos significativos de x
                                // para recorrer las columnas   
// generación del espacio de memoria a leer
always @*
begin
    if (rst)//colocar el código del fondo negro
    begin
        char_addr=2'b00; //la expresión 2'b00, quiere decir un número binario de dos bits de valor cero. El código en memoria del fondo, es el 00
        rom_addr=0; //esto es igual a leer rom_addr=00000000; lo que quiere decir línea 0 del fondo negro. 
    end
    else
    begin
        if(pixel_y>=vinicio && pixel_y<=vfinal) //delimita el espacio a utilizar en y [232-248] y cuando esto sucede, se habilita el pintado de letras
        begin
            if (pixel_x>Iinicio && pixel_x<Ifinal) //delimita el espacio a utilizar en x para I[304-311]
            begin
                char_addr=2'b01; //código de isa es el 01
                row_addr={~pixel_y [3],pixel_y[2:0]}; /*se niega el bit 3 de y, debido a que no tiene el valor deseado inicial
                , o sea, se requiere que inicie en 0, pero se encuentra en 1, o sea, se estaría leyendo de una vez la fila 8 de los espacios
                en memoria, saltanodese las otras filas. Ejemplo, 232=1110 1000, al utilizar solo los bits de 0 a 3, para leer las 16 filas 
                de cada espacio en memoria, se requiere que estos últimos cuatros bits sean 0000. Por eso se niega el primero. Luego concatenar es 
                realizar lo siguiente: tomemos el mismo ejemplo de 1110 1000; al coger solo 1000, lo que se esta haciendo es esto se coge el primer bit
                y se niega, quedando con valor de cero, luego a este bit se le pega a la izquierda los otros bits, o sea los otros tres 0, quedando el código
                0000, el bit que se nego, quedo como el más significativo*/
                rom_addr = {char_addr , row_addr}; /* se realiza la concatenación del código y el número de fila. Ejemplo si esta leyendo 
                la I, el codigo sería 01 y se esta la leyendo la fila número 5, la concatenación quedaría igual a 01 0101, un número hexa de 6bit*/
            end
            else if (pixel_x>Sinicio && pixel_x<Sfinal) //delimita el espacio a utilizar en x para S[316-323]
            begin
                char_addr=2'b10;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
            else if (pixel_x>Ainicio && pixel_x<Afinal) //delimita el espacio a utilizar en x para A[328-335]
            begin
                char_addr=2'b11;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
            else //entre cada letra hay un espacio de 8 pixeles
            begin
                char_addr=2'b00;
                row_addr={~pixel_y [3],pixel_y[2:0]};
                rom_addr = {char_addr , row_addr};
            end
        end 
        else //todo el espacio restante se deja de color de fondo, cuando eno se esta en el sección de pintado
        begin
            char_addr=2'b00;
            row_addr={pixel_y [3],pixel_y[2:0]}; //aca ya no se requiere tanta precición al momento de pintar las filas, por lo cual no se realiza el arreglo del bit 3
            rom_addr = {char_addr , row_addr};
        end 
    end
end

assign bit_addr= pixel_x[2:0]; /*bit addres funcina como las señales de selección de un mux, que eso es exactamente lo que se esta haciendo.
De la fila que se esta leyendo, se va bit por bit, a ver si es un 1 o un 0, para determinar sí se pinta o no.*/
assign font_bit=font_word [~bit_addr]; /*se utiliza el bit addr, ya que, se ocupa pintar la fila desde el bit más significativo hasta el menos
significativo. O sea que se vaya leyendo la fila de derecha a izquierda. O sea que los bits sigan esta secuencia: 7,6,5,4,3,2,1,0*/

always @*
    if (video_on) // Verifica si se esta en la zona de displaya
    begin
        if (font_bit==1) //si el bit a pintar es un 1, se le asignan a los cables auxiliares se les asigna el valor de las entras Rojo, Verde, Azul
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
//Asignación final de las salidas, reciben los valores de los cables auxiliares
assign r = red; // el primer bit corresponde al rojo
assign g = green; // el segundo bit corresponde al verde
assign b = blue;
//assign rowad =rom_addr;
//assign posicion=~bit_addr;
endmodule
