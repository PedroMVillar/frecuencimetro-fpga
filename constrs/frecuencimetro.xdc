## Boolean Board - Frecuencimetro Digital
## Solo se declaran los pines usados por el diseno.

## Clock de 100 MHz
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports {clk}]
create_clock -period 10.000 -name sys_clk [get_ports clk]

## Banco 0
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Reset general -> pulsador BTN0
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {rst}]

## Senial incognita -> los 4 headers de servo.
## El generador se puede enchufar en cualquiera de ellos: el diseno los combina
## con un OR y los que quedan libres estan en 0 por el pull-down de abajo.
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {servo_in[0]}]
set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {servo_in[1]}]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {servo_in[2]}]
set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports {servo_in[3]}]

## Pull-down interno: los headers sin conectar quedan en 0 firme y no cuentan ruido.
## Si tu version de Vivado no acepta PULLTYPE, comentar estas lineas (no es critico).
set_property PULLTYPE PULLDOWN [get_ports {servo_in[0]}]
set_property PULLTYPE PULLDOWN [get_ports {servo_in[1]}]
set_property PULLTYPE PULLDOWN [get_ports {servo_in[2]}]
set_property PULLTYPE PULLDOWN [get_ports {servo_in[3]}]

## Seniales asincronas al clock: entran a un sincronizador, no se analiza su timing.
set_false_path -from [get_ports {servo_in[*]}]

## LED0..LED3 -> espejo de cada header, para ver por cual entra la senial
set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {led_mon[0]}]
set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {led_mon[1]}]
set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {led_mon[2]}]
set_property -dict {PACKAGE_PIN F2 IOSTANDARD LVCMOS33} [get_ports {led_mon[3]}]

## Display de 7 segmentos (modulo D0)
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {D0_AN[0]}]
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {D0_AN[1]}]
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {D0_AN[2]}]
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {D0_AN[3]}]
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[0]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[1]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[2]}]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[3]}]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[4]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[5]}]
set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[6]}]
set_property -dict {PACKAGE_PIN A6 IOSTANDARD LVCMOS33} [get_ports {D0_SEG[7]}]
