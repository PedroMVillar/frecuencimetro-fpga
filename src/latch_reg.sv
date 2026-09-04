`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: latch_reg
// Description: Bloque 5 - Registro de retencion (banco de Flip-Flops tipo D).
//              Copia los 4 digitos BCD a su salida solo cuando latch_en = 1,
//              de modo que el display muestre un valor estable durante toda la
//              siguiente ventana de medicion.
//////////////////////////////////////////////////////////////////////////////////


module latch_reg(
    input  logic       clk,
    input  logic       rst,          // Reset sincrono
    input  logic       latch_en,     // Habilitacion de captura (viene de la FSM)
    input  logic [3:0] d [0:3],      // Digitos provenientes del banco de contadores
    output logic [3:0] q [0:3]       // Digitos retenidos hacia el display
    );

    always_ff @(posedge clk) begin
        if (rst) begin
            for (int i = 0; i < 4; i++) q[i] <= 4'd0;
        end else if (latch_en) begin
            q <= d;
        end
    end

endmodule
