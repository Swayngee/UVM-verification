// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Environment for ALU

class ALU_env extends uvm_env;
//This module just generates stimulus and connects things
	`uvm_component_utils(ALU_env) // UVM macro to register the class with the factory
	//These are pointers
	ALU_agent sa_agent;
	ALU_scoreboard sa_sb;
	//Constructor, registers with env to the heirarchy
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new
	// Creates an agent and a scoreboard
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sa_agent	= ALU_agent::type_id::create(.name("sa_agent"), .parent(this));
		sa_sb		= ALU_scoreboard::type_id::create(.name("sa_sb"), .parent(this));
	endfunction: build_phase
	// Connects the agent analysis ports to the scoreboard analysis exports
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		sa_agent.agent_ap_before.connect(sa_sb.sb_export_before);
		sa_agent.agent_ap_after.connect(sa_sb.sb_export_after);
	endfunction: connect_phase
endclass: ALU_env
