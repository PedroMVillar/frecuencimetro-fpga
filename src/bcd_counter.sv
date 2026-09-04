`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: bcd_counter
// Description: Bloque 2 - Contador BCD sincronico de un digito (0 a 9).
//              Incrementa con 'en', tiene reset sincrono y genera un pulso de
//              carry_out de un ciclo de reloj al pasar de 9 a 0.
//////////////////////////////////////////////////////////////////////////////////


module bcd_counter(
    input  logic       clk,
    input  logic       rst,        // Reset sincrono
    input  logic       en,         // Habilitacion de conteo
    output logic [3:0] count,      // Digito BCD (0000 .. 1001)
    output logic       carry_out   // Pulso de acarreo al desbordar
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            count <= 4'd0;
        end else if (en) begin
            if (count == 4'd9) count <= 4'd0;   // Desborda: vuelve a 0
            else               count <= count + 4'd1;
        end
    end

    // El acarreo vale 1 durante el mismo ciclo en el que el digito pasa de 9 a 0.
    // Como 'en' dura un solo ciclo de reloj, el pulso tambien dura un ciclo.
    assign carry_out = en && (count == 4'd9);

endmodule
