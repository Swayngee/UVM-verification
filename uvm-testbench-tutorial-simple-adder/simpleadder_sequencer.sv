class simpleadder_transaction extends uvm_sequence_item;
	rand bit[1:0] ina; //declares the vars for both inputs. rand stores random values
	rand bit[1:0] inb;
	bit[2:0] out;
	//generates a new class object. Pretty consistent on how this is generated
	function new(string name = "");
		super.new(name);
	endfunction: new
	//UVM Macros to help with printing, copying, comparing, and packing
	`uvm_object_utils_begin(simpleadder_transaction)
		`uvm_field_int(ina, UVM_ALL_ON)
		`uvm_field_int(inb, UVM_ALL_ON)
		`uvm_field_int(out, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: simpleadder_transaction

class simpleadder_sequence extends uvm_sequence#(simpleadder_transaction);
	`uvm_object_utils(simpleadder_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body(); // starts the main task of the sequence
		simpleadder_transaction sa_tx;
		
		repeat(15) begin //starts a cyke for 15 transactions total
		sa_tx = simpleadder_transaction::type_id::create(.name("sa_tx"), .context(get_full_name())); //init a blank transaction

		start_item(sa_tx); // is a call that blocks until the driver accesses the transaction being created
		assert(sa_tx.randomize()); // trigers the rand keyword of the transaction. Randomizes the vars of the transaction
		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
		finish_item(sa_tx); // Another blocking call which blocks until the driver has completed the operation for current transaction
		end
	endtask: body
endclass: simpleadder_sequence

typedef uvm_sequencer#(simpleadder_transaction) simpleadder_sequencer; // This is a typedef for the sequencer class that will be used in the env
