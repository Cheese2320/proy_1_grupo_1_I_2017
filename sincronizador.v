`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.02.2017 08:29:57
// Design Name: 
// Module Name: sincronizador
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


module sincronizador
(
input wire clk, rst,
output hsync, vsync, vidon, divf,
output wire [9:0] px,py
);

//Parámetros para lograr la pantalla 640x480
localparam hd=640; //display horizontal
localparam vd=480;//display vertical
localparam hi=48;//borde izquierdo
localparam hde=16; //borde derecho
localparam hr=96; //retraso horizontal
localparam vsu=33; //borde superior
localparam vin=10; //borde inferior
localparam vr=2; //retraso vertical

//Divisor de frecuencia
wire dv;
div div1(clk,rst,dv);

//contadores de sincronia
reg[9:0] hcr, hcn,help; //help es una variable que utilice para que en cada cuenta del reloj divido, solo se realizará una cuenta en los contadores (previo a esto, esta contando dos veces en cada ciclo)
reg[9:0] vcr, vcn;

//seguidores
reg vsr, hsr;
wire vsn, hsn;

//señales de estado
wire hfin, vfin;

//Módulo sincronizador
//Implementación de los registros
always @(posedge clk, posedge rst)
    if (rst)//pone todo en cero al puro inicio
        begin
            help<=0;
            hcr<=0;
            vcr<=0;
            vsr<=1'b0;
            hsr<=1'b0;
        end
    else
        begin//ciclo que se cumple después del reset
            help<=~help;
            hcr<=hcn;
            vcr<=vcn;
            vsr<=vsn;
            hsr<=hsn;
        end

// h va de 0 a 799 y v va de 0 a 524

assign hfin=(hcr==(hd+hi+hde+hr-1));
assign vfin=(vcr==(vd+vin+vsu+vr-1));
//enables de los contadores
always @*
    if (dv&&help)
        if (hfin)
            hcn=0;
        else
            hcn=hcr+1;
    else
        hcn=hcr;
always @*
    if (dv && hfin&&help)
        if (vfin)
            vcn=0;
        else
            vcn=vcr+1;
    else
        vcn=vcr;
// generar el retraso de de hsync
assign hsn =~(hcr>=(hd+hde-1)&&hcr<(hd+hde+hr-1));
// generar el retraso de de vsync 
assign vsn =~(vcr>=(vin+vd-1)&&vcr<(vd+vin+vr-1));

//señal de habilitación videon
assign vidon=(hcn<hd)&&(vcn<vd);

//señales finales

assign hsync=hsr;
assign vsync=vsr;
assign px=hcr;
assign py=vcr;
assign divf=dv;
endmodule