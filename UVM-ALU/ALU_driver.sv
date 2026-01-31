// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Driver for ALU
import uvm_pkg::*;
`include "uvm_macros.svh"

class ALU_driver extends uvm_driver#(ALU_transaction); 
// The # used above is an SV parameter and it represents the data type used in the sequencer
	`uvm_component_utils(ALU_driver) // Utils macro

	virtual ALU_if vif; // virtual interface handle

	function new(string name, uvm_component parent); // Class constr again
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase); // Starts the build phase of the class. Is executed before the run phase
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual ALU_if)::read_by_name // Gets the interface from the factory database. Same interface instance as in the tb_top
			(.scope("ifs"), .name("ALU_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase); // Run phase where the code of the driver is executed
		drive();
	endtask: run_phase

	virtual task drive(); //Just a combinational task to drive the DUT inputs and capture outputs
		ALU_transaction tr;
        forever begin
            // Get next transaction from sequencer
            seq_item_port.get_next_item(tr);

            // Drive inputs to DUT
            vif.ALUop    <= tr.ALUop;
            vif.funct3   <= tr.funct3;
            vif.funct7b5 <= tr.funct7b5;
            vif.op       <= tr.op;


            // Capture DUT output 
            tr.ALUControl = vif.ALUControl;

            // Tell sequencer we are done with this item
            seq_item_port.item_done();
        end
	endtask drive
endclass: ALU_driver
