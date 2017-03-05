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
input wire clock,
input wire reset,
input wire red,green,blue,
output h_sync,
output v_sync,
output Red,
output Green,
output Blue,
output wire [9:0] px,py,
output wire [5:0] rowad1,
output wire [2:0] pos,
output video
    );
// señales de sincronía
//wire [9:0] p_x1,p_y1;
//wire video;
sincronizador sinc(.clk(clock),.rst(reset),.hsync(h_sync),.vsync(v_sync),.vidon(video),.px(px),.py(py));
caracter car(.clk(clock),.rst(reset),.video_on(video),.pixel_x(px),.pixel_y(py),.R(red),.G(green),.B(blue),.rowad(rowad1),.posicion(pos),.r(Red),.g(Green),.b(Blue));
endmodule
