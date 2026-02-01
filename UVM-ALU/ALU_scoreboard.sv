// Drake Gonzales
// drgonzales@g.hmc.edu
// UVM Scoreboard for ALU



`uvm_analysis_imp_decl(_before) // Generate new analysis implementation classes
`uvm_analysis_imp_decl(_after) // Macros saying I want two independent write entry points
// By doing this u get function void write_before.... function void write_after


class ALU_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(ALU_scoreboard) // UVM macro to register the class with the factory

	uvm_analysis_export #(ALU_transaction) sb_export_before; // Analysis exports (inputs to the scoreboard)
	uvm_analysis_export #(ALU_transaction) sb_export_after;

	uvm_tlm_analysis_fifo #(ALU_transaction) before_fifo; // Analysis FIFOs (buffering and ordering)
	uvm_tlm_analysis_fifo #(ALU_transaction) after_fifo; // FIFOs buffer transactions coming from monitors

	ALU_transaction transaction_before; // Used as resuable containers for data pulled from FIFOs
	ALU_transaction transaction_after;

// Allocates transaction objects once when the scoreboard is created
	function new(string name, uvm_component parent);
		super.new(name, parent);

		transaction_before	= new("transaction_before");
		transaction_after	= new("transaction_after");
	endfunction: new


 // Create objects such as scoreboard inputs and internal buffering(FIFOs)
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		sb_export_before	= new("sb_export_before", this);
		sb_export_after		= new("sb_export_after", this);

   		before_fifo		= new("before_fifo", this);
		after_fifo		= new("after_fifo", this);
	endfunction: build_phase


// Connects the analysis exports to the FIFOs
	function void connect_phase(uvm_phase phase);
		sb_export_before.connect(before_fifo.analysis_export);
		sb_export_after.connect(after_fifo.analysis_export);
	endfunction: connect_phase

	task run_phase(uvm_phase phase);
		forever begin // Blocks until both FIFOs have data, ensures 1-1 comparion
			before_fifo.get(transaction_before);
			after_fifo.get(transaction_after);
			
			compare();
		end
	endtask: run_phase

	virtual function void compare();
		if(transaction_after.ALUControl == transaction_after.ALUControl_expected)
    		`uvm_info("COMPARE", "Test: OK!", UVM_LOW);
		else
    		`uvm_error("COMPARE", $sformatf("FAIL! DUT=%0b, EXPECTED=%0b",
                                     transaction_after.ALUControl,
                                     transaction_after.ALUControl_expected));
	endfunction: compare

endclass: ALU_scoreboard
