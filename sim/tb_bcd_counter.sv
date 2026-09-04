`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench del contador BCD de un digito.
// Verifica el conteo 0..9, el desborde y el pulso de carry_out.
//////////////////////////////////////////////////////////////////////////////////


module tb_bcd_counter;

    logic       clk = 0;
    logic       rst, en;
    logic [3:0] count;
    logic       carry_out;

    bcd_counter dut (.clk(clk), .rst(rst), .en(en), .count(count), .carry_out(carry_out));

    always #5 clk = ~clk;   // Clock de 100 MHz

    int carries = 0;
    always @(posedge clk) if (carry_out) carries++;

    initial begin
        rst = 1; en = 0;
        @(posedge clk);
        rst = 0;

        // 12 pulsos de enable: debe contar 0..9, desbordar y quedar en 2
        for (int i = 0; i < 12; i++) begin
            @(negedge clk); en = 1;
            @(negedge clk); en = 0;
            $display("[%0t] pulso %0d -> count = %0d, carry = %0b", $time, i, count, carry_out);
        end

        @(posedge clk);
        if (count === 4'd2 && carries == 1)
            $display("TEST OK: count = %0d, carries = %0d", count, carries);
        else
            $error("TEST FALLIDO: count = %0d (esperado 2), carries = %0d (esperado 1)", count, carries);

        $finish;
    end

endmodule
