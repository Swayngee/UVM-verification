// Drake Gonzales
// drgonzales@g.hmc.edu
// Configuration class for ALU environment

import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_configuration extends uvm_object;
	`uvm_object_utils(ALU_configuration)

	function new(string name = "");
		super.new(name);
	endfunction: new
endclass: ALU_configuration
