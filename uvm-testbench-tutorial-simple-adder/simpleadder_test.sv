class simpleadder_test extends uvm_test;
		`uvm_component_utils(simpleadder_test) // UVM macro to register the class with the factory

		simpleadder_env sa_env; // Pointer to the env
		//Class create
		function new(string name, uvm_component parent);
			super.new(name, parent);
		endfunction: new
		//Registers test in the heirarchy and creates the env
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sa_env = simpleadder_env::type_id::create(.name("sa_env"), .parent(this));
		endfunction: build_phase

		task run_phase(uvm_phase phase);
			simpleadder_sequence sa_seq;

			phase.raise_objection(.obj(this)); //Don't end the test until sequence ends
				sa_seq = simpleadder_sequence::type_id::create(.name("sa_seq"), .contxt(get_full_name())); //Creates a sequence, a Stim generator
				assert(sa_seq.randomize()); //Randomizes the sequence
				sa_seq.start(sa_env.sa_agent.sa_seqr); // Starts the sequence on the sequencer inside the agent
			phase.drop_objection(.obj(this)); // Tells UVM that im done generating stim, the run phase can end when everything else finishes
		endtask: run_phase
endclass: simpleadder_test
