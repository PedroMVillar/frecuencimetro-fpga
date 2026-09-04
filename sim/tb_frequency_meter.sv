`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench de integracion del frecuencimetro.
//
// La ventana real es de 1 s (1e8 ciclos), imposible de simular en tiempo razonable.
// Por eso el top esta parametrizado: aca se usa DIV_COUNT = 10 y MS_WINDOW = 10,
// o sea una ventana de 100 ciclos de reloj = 1 us.
//
// Con una senial de entrada de periodo 200 ns entran 5 flancos por ventana,
// asi que el display debe quedar en 0 0 0 5.
//////////////////////////////////////////////////////////////////////////////////


module tb_frequency_meter;

    localparam int DIV_COUNT = 10;
    localparam int MS_WINDOW = 10;
    localparam int FREQ_IN_PERIOD = 200;   // ns  -> 5 flancos por ventana de 1 us
    localparam int ESPERADO = 1000 / FREQ_IN_PERIOD;

    logic clk = 0;
    logic rst;
    logic freq_in = 0;
    logic [7:0] D0_SEG;
    logic [3:0] D0_AN;
    logic [3:0] led_mon;

    Frequency_meter #(
        .DIV_COUNT (DIV_COUNT),
        .MS_WINDOW (MS_WINDOW)
    ) dut (
        .clk(clk), .rst(rst), .servo_in({3'b000, freq_in}),
        .D0_SEG(D0_SEG), .D0_AN(D0_AN), .led_mon(led_mon)
    );

    always #5 clk = ~clk;                       // 100 MHz
    always #(FREQ_IN_PERIOD/2) freq_in = ~freq_in;  // Senial incognita

    // Valor completo mostrado en el display (millares..unidades)
    function automatic int valor_display();
        return dut.bcd_disp[3]*1000 + dut.bcd_disp[2]*100 + dut.bcd_disp[1]*10 + dut.bcd_disp[0];
    endfunction

    int medicion = 0;

    // Cada vez que la FSM captura, mostramos el resultado de la ventana
    always @(posedge clk) begin
        if (dut.latch_en) begin
            medicion++;
            #1 $display("[%0t] Medicion %0d -> display = %04d (esperado %0d)",
                        $time, medicion, valor_display(), ESPERADO);
            if (valor_display() < ESPERADO - 1 || valor_display() > ESPERADO + 1)
                $error("Valor fuera de rango");
        end
    end

    initial begin
        // Reset liberado en flanco descendente (ver nota en tb_bcd_counter)
        rst = 1;
        repeat (5) @(negedge clk);
        rst = 0;

        wait (medicion == 4);
        $display("TEST OK: 4 ventanas medidas correctamente");
        $finish;
    end

endmodule
