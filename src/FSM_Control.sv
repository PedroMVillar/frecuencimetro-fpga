`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.08.2026 15:54:55
// Module Name: FSM_Control
// Description: Bloque 4 - Unidad de control. Secuencia Medicion -> Captura ->
//              Reinicio. Mide la ventana de 1 s contando MS_WINDOW ticks de 1 ms.
//////////////////////////////////////////////////////////////////////////////////


module FSM_Control #(
    parameter int MS_WINDOW = 1000      // 1000 ticks de 1 ms = ventana de 1 s
)(
    input  logic clk,
    input  logic rst,
    input  logic tick_1ms,
    output logic cnt_en,
    output logic cnt_rst,
    output logic latch_en
    );

    enum {S_MEDICION, S_CAPTURA, S_REINICIO} state, next_state;

    // Contador de milisegundos para medir la ventana de 1 segundo (0 a MS_WINDOW-1)
    logic [$clog2(MS_WINDOW)-1:0] ms_count;
    logic reset_ms; // Senial de control interna

    // 2. Logica del contador de milisegundos (Secuencial)
    always_ff @(posedge clk) begin
        if (rst || reset_ms) begin
            ms_count <= '0;
        end else if (tick_1ms && state == S_MEDICION) begin
            // Solo incrementa si estamos en el estado de medicion y llega el tick
            ms_count <= ms_count + 1'b1;
        end
    end

    // 3. Registro de Estado (Secuencial)
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= S_MEDICION;
        end else begin
            state <= next_state;
        end
    end

    // 4. Logica de Proximo Estado y Salidas (Combinacional)
    always_comb begin
        // Valores por defecto para evitar latches inferidos
        next_state = state;
        cnt_en     = 1'b0;
        latch_en   = 1'b0;
        cnt_rst    = 1'b0;
        reset_ms   = 1'b0;

        case (state)
            S_MEDICION: begin
                cnt_en = 1'b1; // Dejamos pasar la senial incognita a los contadores

                // Esperamos hasta completar la ventana (de 0 a MS_WINDOW-1)
                if (tick_1ms && (ms_count == MS_WINDOW - 1)) begin
                    next_state = S_CAPTURA;
                end
            end

            S_CAPTURA: begin
                // Al entrar aqui, cnt_en es 0 (detiene el conteo)
                latch_en = 1'b1; // Captura el valor final en el registro de retencion

                // Pasa al siguiente estado en el proximo ciclo de clk (10 ns)
                next_state = S_REINICIO;
            end

            S_REINICIO: begin
                cnt_rst  = 1'b1; // Envia un pulso de reset a los contadores BCD
                reset_ms = 1'b1; // Reinicia el contador de tiempo interno

                // Vuelve a medir en el proximo ciclo de clk
                next_state = S_MEDICION;
            end

            default: next_state = S_MEDICION;
        endcase
    end

endmodule
