// Drake Gonzales
// drgonzales@g.hmc.edu
// Package file for ALU UVM components
import uvm_pkg::*;
`include "uvm_macros.svh"

package ALU_pkg;

	`include "ALU_sequencer.sv"
	`include "ALU_monitor.sv"
	`include "ALU_driver.sv"
	`include "ALU_agent.sv"
	`include "ALU_scoreboard.sv"
	`include "ALU_config.sv"
	`include "ALU_env.sv"
	`include "ALU_test.sv"
endpackage: ALU_pkg
