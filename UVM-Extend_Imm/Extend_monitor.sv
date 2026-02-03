// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Monitor for Extend

import uvm_pkg::*;
`include "uvm_macros.svh"

class Extend_monitor_before extends uvm_monitor;
	`uvm_component_utils(Extend_monitor_before)

	uvm_analysis_port#(Extend_transaction) mon_ap_before;

	virtual Extend_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual Extend_if)::read_by_name
			(.scope("ifs"), .name("Extend_if"), .val(vif)));
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
	endfunction: build_phase

    task run_phase(uvm_phase phase);
        Extend_transaction tr;
        forever begin
            // Sample the inputs 
            tr = Extend_transaction::type_id::create("tr");
            tr.Instr    = vif.sig_Instr;
            tr.ImmSrc   = vif.sig_ImmSrc;

            // Send to analysis port
            mon_ap_before.write(tr);
	    #1;
        end
    endtask
endclass: Extend_monitor_before

class Extend_monitor_after extends uvm_monitor;
	`uvm_component_utils(Extend_monitor_after)

	uvm_analysis_port#(Extend_transaction) mon_ap_after;

	virtual Extend_if vif;

	Extend_transaction sa_tx;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual Extend_if)::read_by_name
			(.scope("ifs"), .name("Extend_if"), .val(vif)));
		mon_ap_after= new(.name("mon_ap_after"), .parent(this));
	endfunction: build_phase

   task run_phase(uvm_phase phase);
        Extend_transaction tr;
        forever begin
            // Sample inputs + outputs in one transaction
            tr = Extend_transaction::type_id::create("tr");
            tr.Instr    = vif.sig_Instr;
            tr.ImmSrc   = vif.sig_ImmSrc;
            tr.ImmExt   = vif.ImmExt;

            // calculate expected value
            tr.ImmExt_expected = predictor(tr);

            // Send to analysis port
            mon_ap_after.write(tr);
	    #1;
        end
    endtask

virtual function bit [31:0] predictor(Extend_transaction tr); //basically our ALUdecoder logic to predict output
  case (tr.Immsrc)
    2'b00: predictor = {{20{tr.Instr[31]}}, tr.Instr[31:20]};
    2'b01: predictor = {{20{tr.Instr[31]}}, tr.Instr[31:25], tr.Instr[11:7]};
    2'b10: predictor = {{20{tr.Instr[31]}}, tr.Instr[7],
                      tr.Instr[30:25], tr.Instr[11:8], 1'b0};
    2'b11: predictor = {{12{tr.Instr[31]}}, tr.Instr[19:12],
                      tr.Instr[20], tr.Instr[30:21], 1'b0};
  endcase
endfunction: predictor
endclass: Extend_monitor_after
