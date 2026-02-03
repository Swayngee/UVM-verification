// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Sequencer and Transaction for Extend

import uvm_pkg::*;
`include "uvm_macros.svh"

class Extend_transaction extends uvm_sequence_item;
    rand bit [31:7] Instr;       // matches DUT input
    rand bit [1:0] ImmSrc;      // matches DUT input

    bit [31:0] ImmExt; // matches DUT output
	bit [31:0] ImmExt_expected; // expected output for checking


	//generates a new class object. Pretty consistent on how this is generated
	function new(string name = "");
		super.new(name);
	endfunction: new

	//UVM Macros to help with printing, copying, comparing, and packing
	`uvm_object_utils_begin(Extend_transaction)
		`uvm_field_int(Instr, UVM_ALL_ON)
		`uvm_field_int(ImmSrc, UVM_ALL_ON)
		`uvm_field_int(ImmExt, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: Extend_transaction

class Extend_sequence extends uvm_sequence#(Extend_transaction);
	`uvm_object_utils(Extend_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body(); // starts the main task of the sequence
		Extend_transaction sa_tx;
		
		repeat(15) begin //starts a cycle for 15 transactions total
		sa_tx = Extend_transaction::type_id::create("sa_tx");

		start_item(sa_tx); // is a call that blocks until the driver accesses the transaction being created
		assert(sa_tx.randomize()); // trigers the rand keyword of the transaction. Randomizes the vars of the transaction
		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
		finish_item(sa_tx); // Another blocking call which blocks until the driver has completed the operation for current transaction
		end
	endtask: body
endclass: Extend_sequence

typedef uvm_sequencer#(Extend_transaction) Extend_sequencer; // This is a typedef for the sequencer class that will be used in the env
