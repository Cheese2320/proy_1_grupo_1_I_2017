`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.03.2017 08:16:18
// Design Name: 
// Module Name: VGA
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


module VGA(
//declaración de entradas y salidas
input wire clk,
input wire reset,
input wire red,green,blue,
output h_sync,
output v_sync,
output Red,
output Green,
output Blue
//output wire [5:0] rowad1,
//output wire [2:0] pos
    );
// señales de sincronía; estas señales se utilizan para que reciban los valores generados por los módulos y poder trabajar con ellas.
wire [9:0] p_x1,p_y1;
wire video;
// instaciamiento de los módulos. Tomar en cuenta, que las variables se colocan según el orden en que fueron declaradas en el módulo original.
sincronizador sinc(.clk(clk),
                   .rst(reset),
                   .hsync(h_sync),
                   .vsync(v_sync),
                   .vidon(video),
                   .px(p_x1),
                   .py(p_y1));
caracter car(.clk(clk),
             .rst(reset),
             .video_on(video),
             .pixel_x(p_x1),
             .pixel_y(p_y1),
             .R(red),
             .G(green),
             .B(blue),
             .r(Red),
             .g(Green),
             .b(Blue));
endmodule
