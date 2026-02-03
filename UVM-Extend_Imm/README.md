# UVM testbenching
# Extend Immediate module for a RISC-V processor

## Overview
The following code was written as a second attempt at UVM methodology, for a purely combinational method. I wanted to test the continuity of combinational UVM in two different modules before I moved onto clocked modules. 

This project was chosen as a start for verifying direct computer hardware. 

## Progress 
The above UVM testbench was designed to verify a simple combinational ImmExt for a RISCV multicycle processor. The simulation of the code was a success as seen below. 

![UVM output using Questa Intel FPGA Edition](images/ExtImm.png)

Similar to the ALUDecoder UVM, this code (a combinational block) was relatively straight forward. Although I did run more tests (100) to test more test case coverage. 

Written by Drake Gonzales 2/2/26
