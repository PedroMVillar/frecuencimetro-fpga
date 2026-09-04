`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.08.2026 15:03:41
// Module Name: BaseTime1ms
// Description: Bloque 1 - Base de tiempo. Divisor de frecuencia que genera un
//              pulso de un ciclo de reloj cada 1 ms a partir del clock de 100 MHz.
//              La ventana de 1 s se completa contando 1000 de estos ticks dentro
//              de la FSM de control.
//              El parametro DIV_COUNT permite acortar el tiempo en simulacion.
//////////////////////////////////////////////////////////////////////////////////


module BaseTime1ms #(
    parameter int DIV_COUNT = 100_000   // 100 MHz / 100.000 = 1 kHz -> 1 ms
)(
    input  logic clk_in,       // 100MHz CLK Input
    input  logic rst,          // Sync reset
    output logic tick_out      // 1ms Tick signal
    );

    logic [$clog2(DIV_COUNT)-1:0] cnt;

    always_ff @(posedge clk_in) begin
        if (rst) begin
            cnt      <= '0;
            tick_out <= 1'b0;
        end else begin
            if (cnt == DIV_COUNT - 1) begin
                cnt      <= '0;
                tick_out <= 1'b1; // Emitimos el pulso de 1 ms
            end else begin
                cnt      <= cnt + 1'b1;
                tick_out <= 1'b0; // Mantenemos el pulso en 0 el resto del tiempo
            end
        end
    end

endmodule
