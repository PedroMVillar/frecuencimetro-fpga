#######################################################################
# Configuracion del waveform para tb_frequency_meter (Vivado xsim).
#
# Uso: con la simulacion behavioral ya abierta, en la consola Tcl de la
# ventana de simulacion escribir:
#
#   source {C:/ruta/al/repo/frecuencimetro-fpga/sim/wave_frequency_meter.tcl}
#
# Reinicia la simulacion, agrega las señales que importan y corre hasta
# el final. Despues apretar "Zoom Fit" en la barra del waveform.
#######################################################################

set TB  /tb_frequency_meter
set DUT $TB/dut

# Limpia el waveform actual (si esta vacio, no pasa nada)
catch {remove_wave [get_waves *]}

restart

# --- Entrada ---
add_wave $TB/freq_in                    ;# Senial incognita (200 ns de periodo)

# --- Base de tiempo y unidad de control ---
add_wave $DUT/tick_1ms                  ;# Un pulso cada 100 ns en simulacion
add_wave $DUT/u_fsm/state               ;# S_MEDICION -> S_CAPTURA -> S_REINICIO
add_wave $DUT/cnt_en                    ;# Ventana de medicion abierta
add_wave $DUT/latch_en                  ;# Pulso de captura (1 ciclo)
add_wave $DUT/cnt_rst                   ;# Pulso de reinicio (1 ciclo)

# --- Camino de datos ---
add_wave $DUT/count_pulse               ;# Un pulso por flanco de freq_in
add_wave -radix unsigned $DUT/bcd_count ;# Contadores BCD (se reinician cada ventana)
add_wave -radix unsigned $DUT/bcd_disp  ;# Valor retenido: queda quieto en 5

# --- Testbench ---
add_wave -radix unsigned $TB/medicion   ;# Numero de ventana completada

run -all
