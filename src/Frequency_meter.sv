`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 24.08.2026 16:15:27
// Module Name: Frequency_meter
// Description: Bloque 6 - Top Level del frecuencimetro digital.
//              Integra base de tiempo, FSM de control, banco de contadores BCD,
//              registro de retencion y el controlador de display de la catedra.
//////////////////////////////////////////////////////////////////////////////////


module Frequency_meter #(
    parameter int DIV_COUNT = 100_000,  // Ciclos de 100 MHz por tick (1 ms)
    parameter int MS_WINDOW = 1000      // Ticks por ventana de medicion (1 s)
)(
    input  logic       clk,       // 100 MHz de la Boolean Board
    input  logic       rst,       // Reset general (pulsador)
    input  logic       servo0,    // Senial incognita: header de servo0 (M14)
    output logic [7:0] D0_SEG,
    output logic [3:0] D0_AN
    );

    logic tick_1ms;
    logic cnt_en, cnt_rst, latch_en;
    logic [3:0] bcd_count [0:3];    // Salida viva de los contadores
    logic [3:0] bcd_disp  [0:3];    // Valor retenido que se muestra
    logic [13:0] cnt_display = '0;

    // ---------------- Bloque 1: Base de tiempo ----------------
    BaseTime1ms #(.DIV_COUNT(DIV_COUNT)) u_base_time (
        .clk_in     (clk),
        .rst        (rst),
        .tick_out   (tick_1ms)
    );

    // ---------------- Bloque 4: Unidad de control ----------------
    FSM_Control #(.MS_WINDOW(MS_WINDOW)) u_fsm (
        .clk        (clk),
        .rst        (rst),
        .tick_1ms   (tick_1ms),
        .cnt_en     (cnt_en),
        .cnt_rst    (cnt_rst),
        .latch_en   (latch_en)
    );

    // ---------------- Bloque 3: Banco de contadores BCD ----------------
    // El banco se clockea con la senial incognita: cada flanco ascendente hace
    // avanzar los contadores, y la FSM decide con 'en' si ese flanco se cuenta o no.
    bcd_counter_bank u_bank (
        .clk        (servo0),
        .rst        (rst || cnt_rst),
        .en         (cnt_en),
        .bcd        (bcd_count)
    );

    // ---------------- Bloque 5: Registro de retencion ----------------
    latch_reg u_latch (
        .clk        (clk),
        .rst        (rst),
        .latch_en   (latch_en),
        .d          (bcd_count),
        .q          (bcd_disp)
    );

    // ---------------- Modulo de display (provisto por la catedra) ----------------
    // bcd_disp[0] = unidades ... bcd_disp[3] = millares.
    // Si en la placa los digitos aparecen invertidos, alcanza con invertir el
    // orden del arreglo en esta conexion.
    disp7seg_controller dispA (
        .clk        (cnt_display[13]),
        .bcd_dig    (bcd_disp),
        .blank_dig  (4'b0000),
        .seg        (D0_SEG),
        .dig_en     (D0_AN)
    );

    always_ff @(posedge clk) cnt_display <= cnt_display + 1;

endmodule
