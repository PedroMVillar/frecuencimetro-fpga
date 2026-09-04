`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: bcd_counter_bank
// Description: Bloque 3 - Banco de 4 contadores BCD en cascada.
//              bcd[0] = Unidades, bcd[1] = Decenas,
//              bcd[2] = Centenas, bcd[3] = Millares.
//              El carry_out de cada digito habilita al digito siguiente.
//////////////////////////////////////////////////////////////////////////////////


module bcd_counter_bank(
    input  logic       clk,
    input  logic       rst,        // Reset sincrono de todos los digitos
    input  logic       en,         // Un pulso por cada flanco de la senial incognita
    output logic [3:0] bcd [0:3]   // Valor de los 4 digitos
    );

    logic carry [0:3];

    // Unidades: se habilitan directamente con el pulso de entrada
    bcd_counter u_unidades (
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        .count      (bcd[0]),
        .carry_out  (carry[0])
    );

    // Decenas, Centenas y Millares: cada uno se habilita con el acarreo del anterior
    bcd_counter u_decenas (
        .clk        (clk),
        .rst        (rst),
        .en         (carry[0]),
        .count      (bcd[1]),
        .carry_out  (carry[1])
    );

    bcd_counter u_centenas (
        .clk        (clk),
        .rst        (rst),
        .en         (carry[1]),
        .count      (bcd[2]),
        .carry_out  (carry[2])
    );

    bcd_counter u_millares (
        .clk        (clk),
        .rst        (rst),
        .en         (carry[2]),
        .count      (bcd[3]),
        .carry_out  (carry[3])   // Overflow del contador (>9999), no se usa
    );

endmodule
