// Drake Gonzales
// drgonzales@g.hmc.edu
// Top-level testbench for ALU UVM verification

`include "ALU_if.sv"
`include "ALUDecoder.sv"
`include "ALU_pkg.sv"

module ALU_tb_top;
	import ALU_pkg::*;
	
	//Interface declaration
	ALU_if vif();

	//Connects the Interface to the DUT
	ALUDecoder dut(
		.ALUop(vif.sig_ALUop),
		.funct3(vif.sig_funct3),
		.funct7b5(vif.sig_funct7b5),
		.op(vif.sig_op),
		.ALUControl(vif.ALUControl)
	);

	initial begin
		//Registers the Interface in the configuration block so that other
		//blocks can use it
		uvm_resource_db#(virtual ALU_if)::set
			(.scope("ifs"), .name("ALU_if"), .val(vif));

		//Executes the test
		run_test();
	end
endmodule
