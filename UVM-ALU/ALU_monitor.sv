class ALU_monitor_before extends uvm_monitor;
	`uvm_component_utils(ALU_monitor_before)

	uvm_analysis_port#(ALU_transaction) mon_ap_before;

	virtual ALU_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual ALU_if)::read_by_name
			(.scope("ifs"), .name("ALU_if"), .val(vif)));
		mon_ap_before = new(.name("mon_ap_before"), .parent(this));
	endfunction: build_phase

    task run_phase(uvm_phase phase);
        ALU_transaction tr;
        forever begin
            // Sample the inputs 
            tr = ALU_transaction::type_id::create("tr");
            tr.ALUop    = vif.ALUop;
            tr.funct3   = vif.funct3;
            tr.funct7b5 = vif.funct7b5;
            tr.op       = vif.op;

            // Send to analysis port
            mon_ap_before.write(tr);

        end
    endtask
endclass: ALU_monitor_before

class ALU_monitor_after extends uvm_monitor;
	`uvm_component_utils(ALU_monitor_after)

	uvm_analysis_port#(ALU_transaction) mon_ap_after;

	virtual ALU_if vif;

	ALU_transaction sa_tx;
	

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		void'(uvm_resource_db#(virtual ALU_if)::read_by_name
			(.scope("ifs"), .name("ALU_if"), .val(vif)));
		mon_ap_after= new(.name("mon_ap_after"), .parent(this));
	endfunction: build_phase

   task run_phase(uvm_phase phase);
        ALU_transaction tr;
        forever begin
            // Sample inputs + outputs in one transaction
            tr = ALU_transaction::type_id::create("tr");
            tr.ALUop    = vif.ALUop;
            tr.funct3   = vif.funct3;
            tr.funct7b5 = vif.funct7b5;
            tr.op       = vif.op;
            tr.ALUControl = vif.ALUControl;

            // calculate expected value
            tr.ALUControl_expected = predictor(tr);

            // Send to analysis port
            mon_ap_after.write(tr);
        end
    endtask

    virtual function bit [2:0] predictor(ALU_transaction tr); //basically our ALUdecoder logic to predict output
	case (tr.ALUop)
    2'b00: predictor = 3'b000;
    2'b01: predictor = 3'b001;
    2'b10: 
        case(tr.funct3)
            3'b000: if (tr.op==0) predictor = 3'b000;
                else if (tr.funct7b5==0) predictor = 3'b000;
                else predictor = 3'b001;
            3'b010: predictor = 3'b101;
            3'b110: predictor = 3'b011;
            3'b111: predictor = 3'b010;
        default: predictor = 3'b000;
        endcase    
		default: predictor = 3'b000;
	endcase
endfunction: predictor
endclass: ALU_monitor_after
