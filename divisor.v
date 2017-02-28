`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.02.2017 16:51:21
// Design Name: 
// Module Name: divisor
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


module div (clk,reset, clk_out);
// definici�n de entradas y salidas
input clk;
input reset;
output clk_out;
//variables de ayuda
reg [1:0] r_reg;
wire [1:0] r_nxt;
reg clk_track;
//inicializaci�n de registros
always @(posedge clk,posedge reset)
 
begin
  if (reset) //condici�n de reset, pone valores iniciales al inici� de cada ejecuci�n
     begin
        r_reg <= 2'b01;//se puso en 1 en vez de cero, para que la se�al de salida de este m�dulo concuerde con la del clock. O sea que en el primer ciclo que realice el clk principal, este tambi�n inicie a dividir dicha se�al.
        clk_track <= 1'b0;
     end
  else if (r_nxt == 2'b10)//se realiza la primera divisi�n entre dos
 	   begin
	     r_reg <= 0;
	     clk_track <= ~clk_track; //realiza la segunda divisi�n entre dos
	   end
  else 
      r_reg <= r_nxt;
end
 assign r_nxt = r_reg+1;   	      
 assign clk_out = clk_track; //se�al dividida en 4
endmodule
