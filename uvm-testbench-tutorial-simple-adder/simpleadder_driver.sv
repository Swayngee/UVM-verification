class simpleadder_driver extends uvm_driver#(simpleadder_transaction); // derives a class names simple_adder_driver from the UVM class uvm_driver
// The # used above is an SV parameter and it represents the data type used in the sequencer
	`uvm_component_utils(simpleadder_driver) // Utils macro

	virtual simpleadder_if vif; // virtual interface handle

	function new(string name, uvm_component parent); // Class constr again
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase); // Starts the build phase of the class. Is executed before the run phase
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual simpleadder_if)::read_by_name // Gets the interface from the factory database. Same interface instance as in the tb_top
			(.scope("ifs"), .name("simpleadder_if"), .val(vif)));
	endfunction: build_phase

	task run_phase(uvm_phase phase); // Run phase where the code of the driver is executed
		drive();
	endtask: run_phase

	virtual task drive();
		simpleadder_transaction sa_tx;
		integer counter = 0, state = 0;
		vif.sig_ina = 0'b0;
		vif.sig_inb = 0'b0;
		vif.sig_en_i = 1'b0;

		forever begin
			if(counter==0)
			begin
				seq_item_port.get_next_item(sa_tx);
				//`uvm_info("sa_driver", sa_tx.sprint(), UVM_LOW);
			end

			@(posedge vif.sig_clock)
			begin //state 0 drives en_o
				if(counter==0)
				begin
					vif.sig_en_i = 1'b1;
					state = 1;
				end

				if(counter==1)
				begin
					vif.sig_en_i = 1'b0;
				end

				case(state)
					1: begin // state 1 transmite the inputs ina and inb
						vif.sig_ina = sa_tx.ina[1];
						vif.sig_inb = sa_tx.inb[1];

						sa_tx.ina = sa_tx.ina << 1;
						sa_tx.inb = sa_tx.inb << 1;
						
						counter = counter + 1;
						if(counter==2) state = 2;
					end

					2: begin // state 2 waits for the DUT to respond
						vif.sig_ina = 1'b0;
						vif.sig_inb = 1'b0;
						counter = counter + 1;
						//After the supposed response, the TB starts over
						if(counter==6)
						begin
							counter = 0;
							state = 0;
							// Tells the sequencer that you are done processing current sequence item
							seq_item_port.item_done();
						end
					end
				endcase
			end
		end
	endtask: drive
endclass: simpleadder_driver
