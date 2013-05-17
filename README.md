MAF
===
Moving Avergare Filter (MAF) in VHDL 2008 for DE0-NANO with FPGA Cyclone IV.

This filter works with fixed point that the number of bits depends on the ADC.


About the Moving Average Filter
===============================
A Moving Average Filter is a digital filter that average of the input's last
M + 1 terms such as the following expresion:

            x[n] + x[n-1] + .... + x[n-M]

    y[n] =  -----------------------------

                        M + 1

Using the second direct-form we can define h[n] like this:
    h[n] = x[n] + h[n-1]

So y[n] can be expresed in this waw:
    y[n] = (h[n] - h[n-M]) / (M + 1)

Structure of the filter
=======================
The Top Hierarchy is maftop.vhd that define all the filter's structure.

delayer.vhd
-----------
To generate from h[n-1] to h[n-M], flip-flops are used to delays.
