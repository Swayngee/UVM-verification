// Drake Gonzales
// drgonzales@g.hmc.edu
// Configuration class for Extend environment

import uvm_pkg::*;
`include "uvm_macros.svh"

class Extend_configuration extends uvm_object;
	`uvm_object_utils(Extend_configuration)

	function new(string name = "");
		super.new(name);
	endfunction: new
endclass: Extend_configuration
