// Drake Gonzales
// drgonzales@g.hmc.edu
// This is the UVM agent for the Extend

import uvm_pkg::*;
`include "uvm_macros.svh"

class Extend_agent extends uvm_agent;
	`uvm_component_utils(Extend_agent)
	// Analysius ports to connect the monitors to the scoreboard
	uvm_analysis_port#(Extend_transaction) agent_ap_before;
	uvm_analysis_port#(Extend_transaction) agent_ap_after;

	Extend_sequencer		sa_seqr;
	Extend_driver		sa_drvr;
	Extend_monitor_before	sa_mon_before;
	Extend_monitor_after	sa_mon_after;
	// creates constructor -- thing that runs the moment an object is created
	// Here a constructor is given its name, attaches it to a parent, and registers it with the UWM infastructure
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new


// Where the UVM component creates its resources
	function void build_phase(uvm_phase phase);
		super.build_phase(phase); // this will build the component
		//cretes analysis ports. These exists so monitors can broadcast transactions to the scoreboard
		agent_ap_before	= new(.name("agent_ap_before"), .parent(this));
		agent_ap_after	= new(.name("agent_ap_after"), .parent(this));
	// //Correct UVM way to create sequencers, drivers, monitors, agents, envs
		sa_seqr		= Extend_sequencer::type_id::create(.name("sa_seqr"), .parent(this));
		sa_drvr		= Extend_driver::type_id::create(.name("sa_drvr"), .parent(this));
		sa_mon_before	= Extend_monitor_before::type_id::create(.name("sa_mon_before"), .parent(this));
		sa_mon_after	= Extend_monitor_after::type_id::create(.name("sa_mon_after"), .parent(this));
	endfunction: build_phase


//build phase makes parts, connects plugs in the cables
//Where UVM connects ports/exports so data can flow
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase); // Allows base classes to make own connections
		
		sa_drvr.seq_item_port.connect(sa_seqr.seq_item_export); //Driver ->sequencer connection
		sa_mon_before.mon_ap_before.connect(agent_ap_before); // Monitor ->Agent analysis port (Before)
		sa_mon_after.mon_ap_after.connect(agent_ap_after); //Monitor -> Agent analysis port (AFTER)
	endfunction: connect_phase
endclass: Extend_agent
