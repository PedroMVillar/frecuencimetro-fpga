# Frecuencímetro Digital en FPGA — Boolean Board

TP de Laboratorio de Arquitectura (FAMAF). Mide la frecuencia de una señal por el
método directo: cuenta flancos ascendentes durante una ventana de exactamente 1 s
y muestra el resultado en el display de 7 segmentos.

## Estructura

```
src/     Diseño sintetizable
  BaseTime1ms.sv        Bloque 1 - base de tiempo (tick cada 1 ms)
  bcd_counter.sv        Bloque 2 - contador BCD de un dígito con carry_out
  bcd_counter_bank.sv   Bloque 3 - 4 contadores BCD en cascada
  FSM_Control.sv        Bloque 4 - FSM: Medición -> Captura -> Reinicio
  latch_reg.sv          Bloque 5 - registro de retención (FF tipo D)
  Frequency_meter.sv    Bloque 6 - Top Level
  disp7seg_controller.sv  Módulo de display provisto por la cátedra
sim/     Testbenches
  tb_bcd_counter.sv     Test unitario del contador BCD
  tb_frequency_meter.sv Test de integración (ventana acortada por parámetros)
constrs/
  frecuencimetro.xdc    Pines usados por el diseño
docs/
  boolean_master.xdc    XDC completo de la placa (referencia)
  [GUIA LAB]Lab1_Frecuencimetro.pdf
```

## Cómo funciona

- `BaseTime1ms` divide los 100 MHz y emite un pulso cada 1 ms (100.000 ciclos).
- `FSM_Control` cuenta 1000 de esos ticks: eso arma la ventana de 1 s. Durante ese
  tiempo mantiene `cnt_en = 1`. Al terminar pasa un ciclo por **Captura**
  (`latch_en`) y otro por **Reinicio** (`cnt_rst`), y vuelve a medir.
- En el top, la señal incógnita se sincroniza con dos flip-flops y se le detecta el
  flanco ascendente: cada flanco genera un pulso de un ciclo que habilita al banco
  BCD. Así los contadores son 100% síncronos al clock de la placa.
- El banco encadena 4 contadores BCD: el `carry_out` de las unidades habilita a las
  decenas, y así hasta los millares (rango 0000–9999 Hz).
- El `latch_reg` congela el valor al final de cada ventana, para que el display no
  parpadee mientras se está contando.

## Simulación en Vivado

1. `Flow > Simulation Settings > Simulation top module name` = `tb_frequency_meter`
   (o `tb_bcd_counter`).
2. `Run Simulation > Run Behavioral Simulation`.

El testbench de integración instancia el top con `DIV_COUNT = 10` y `MS_WINDOW = 10`,
o sea una ventana de 1 µs en vez de 1 s (una ventana real serían 10⁸ ciclos,
imposible de simular). Con una entrada de 200 ns de período deben entrar 5 flancos
por ventana, así que la consola tiene que imprimir `display = 0005`.

## Implementación en la placa

- `clk` → oscilador de 100 MHz (F14)
- `rst` → BTN0
- `freq_in` → BTN1 (prueba manual; los rebotes suman cuentas) o pin M14 del header
  de servos para un generador de funciones (ver comentario en el XDC)
- `D0_SEG` / `D0_AN` → display de 7 segmentos
