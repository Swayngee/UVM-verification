interface ALU_if;
	logic [1:0]		sig_ALUop;
	logic [2:0]		sig_funct3;
	logic		sig_funct7b5;
	logic		sig_op;

	logic [2:0]		ALUControl;
endinterface: ALU_if
