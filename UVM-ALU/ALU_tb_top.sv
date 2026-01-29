// Drake Gonzales
// drgonzales@g.hmc.edu
// Top-level testbench for ALU UVM verification

`include "ALU_pkg.sv"
`include "ALU.sv" //import the DUT
`include "ALU_if.sv" //import the adder interface

module ALU_tb_top;
	import uvm_pkg::*; // imports the UVM library

	//Interface declaration
	ALU_if vif(); // <- declares signals 

	//Connects the Interface to the DUT
	ALU_Decoder dut(vif.sig_ALUop,
			vif.sig_funct3,
			vif.sig_funct7b5,
			vif.sig_op,
			vif.ALUControl);



	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual ALU_if)::set
			(.scope("ifs"), .name("ALU_if"), .val(vif));

		//Executes the test
		run_test(); // literally runs the verilog simulation
	end
endmodule
