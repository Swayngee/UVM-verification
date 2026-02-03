// Drake Gonzales
// drgonzales@g.hmc.edu
// ALU interface definition

interface Extend_if;
	logic [31:7]	sig_Instr;
	logic [1:0]		sig_ImmSrc;

	logic [31:0]	ImmExt;
endinterface: Extend_if
