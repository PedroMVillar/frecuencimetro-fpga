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
    input  logic       clk,        // 100 MHz de la Boolean Board
    input  logic       rst,        // Reset general (pulsador)
    input  logic [3:0] servo_in,   // Senial incognita: los 4 headers de servo
    output logic [7:0] D0_SEG,
    output logic [3:0] D0_AN,
    output logic [3:0] led_mon     // Espejo de cada header (diagnostico de banco)
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

    // ------- Sincronizacion y deteccion de flanco de la senial incognita -------
    // La senial externa es asincrona respecto del clock de 100 MHz: se registra
    // dos veces para evitar metaestabilidad y se genera un pulso de un ciclo por
    // cada flanco ascendente. Ese pulso es lo que realmente cuenta el banco BCD.
    //
    // Se escuchan los cuatro headers de servo en paralelo y se los combina con un
    // OR: los pines sin conectar tienen pull-down (ver XDC), asi que valen 0 firme
    // y no aportan nada. En la practica esto significa que el generador se puede
    // enchufar en cualquiera de los cuatro headers y el frecuencimetro igual mide.
    logic [3:0] servo_sync0, servo_sync1;
    logic freq_level, freq_prev;
    logic count_pulse;

    always_ff @(posedge clk) begin
        servo_sync0 <= servo_in;
        servo_sync1 <= servo_sync0;
        freq_prev   <= freq_level;
    end

    assign freq_level  = |servo_sync1;
    assign count_pulse = cnt_en && freq_level && !freq_prev;

    // Monitor de banco: cada LED espeja su header ya sincronizado. Si ningun LED
    // reacciona con el generador conectado, la senial no esta llegando a la FPGA.
    assign led_mon = servo_sync1;

    // ---------------- Bloque 3: Banco de contadores BCD ----------------
    bcd_counter_bank u_bank (
        .clk        (clk),
        .rst        (rst || cnt_rst),
        .en         (count_pulse),
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
