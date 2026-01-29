// Drake Gonzales
// drgonzales@g.hmc.edu
// Below is the ALU for a Multicycle RISC-V CPU

module ALUDecoder(input logic [1:0] ALUop,
                input logic [2:0] funct3,
                input logic funct7b5,
                input logic       op,
                output logic [2:0] ALUControl);

always_comb begin
case (ALUop)
    2'b00: ALUControl = 3'b000;
    2'b01: ALUControl = 3'b001;
    2'b10: 
        case(funct3)
            3'b000: if (op==0) ALUControl = 3'b000;
                else if (funct7b5==0) ALUControl = 3'b000;
                else ALUControl = 3'b001;
            3'b010: ALUControl = 3'b101;
            3'b110: ALUControl = 3'b011;
            3'b111: ALUControl = 3'b010;
        default: ALUControl = 3'b000;
        endcase
        
default: ALUControl = 3'b000;
endcase
end
endmodule