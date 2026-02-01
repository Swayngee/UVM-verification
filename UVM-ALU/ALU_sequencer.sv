// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Sequencer and Transaction for ALU
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_transaction extends uvm_sequence_item;
    rand bit [1:0] ALUop;       // matches DUT input
    rand bit [2:0] funct3;      // matches DUT input
    rand bit        funct7b5;   // matches DUT input
    rand bit        op;          // matches DUT input

    bit [2:0] ALUControl; // matches DUT output
	bit [2:0] ALUControl_expected; // expected output for checking


	//generates a new class object. Pretty consistent on how this is generated
	function new(string name = "");
		super.new(name);
	endfunction: new

	//UVM Macros to help with printing, copying, comparing, and packing
	`uvm_object_utils_begin(ALU_transaction)
		`uvm_field_int(ALUop, UVM_ALL_ON)
		`uvm_field_int(funct3, UVM_ALL_ON)
		`uvm_field_int(funct7b5, UVM_ALL_ON)
		`uvm_field_int(op, UVM_ALL_ON)
		`uvm_field_int(ALUControl, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: ALU_transaction

class ALU_sequence extends uvm_sequence#(ALU_transaction);
	`uvm_object_utils(ALU_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body(); // starts the main task of the sequence
		ALU_transaction sa_tx;
		
		repeat(15) begin //starts a cycle for 15 transactions total
		sa_tx = ALU_transaction::type_id::create("sa_tx");

		start_item(sa_tx); // is a call that blocks until the driver accesses the transaction being created
		assert(sa_tx.randomize()); // trigers the rand keyword of the transaction. Randomizes the vars of the transaction
		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
		finish_item(sa_tx); // Another blocking call which blocks until the driver has completed the operation for current transaction
		end
	endtask: body
endclass: ALU_sequence

typedef uvm_sequencer#(ALU_transaction) ALU_sequencer; // This is a typedef for the sequencer class that will be used in the env
