MAF
===

Moving Avergare Filter (MAF) in VHDL for DE0-NANO with FPGA Cyclone IV.

This filter works with fixed point that the number orf bits depends
on the ADC.


About the Moving Average Filter
===============================
A Moving Average Filter is a digital filter that average of the input's last M
term such as the following expresion:

        x[n] + x[n-1] + .... + x[M-1]

y[n] =  -----------------------------

                      M
