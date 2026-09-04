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

## Senial incognita -> pulsador BTN1 (para probar a mano, con rebotes)
set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {freq_in}]

## Alternativa: senial incognita desde un generador de funciones en el pin
## del header de servos (servo0). Comentar la linea de arriba y descomentar esta.
#set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports {freq_in}]

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
