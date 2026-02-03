// Drake Gonzales
// drgonzales@g.hmc.edu
// Top-level testbench for ALU UVM verification
`include "uvm_macros.svh"  
`include "ALU_if.sv"
`include "ALUDecoder.sv"
`include "ALU_pkg.sv"

module ALU_tb_top;
    import uvm_pkg::*;
    import ALU_pkg::*;

    // Real interface instance
    ALU_if vif_inst();

    // Virtual handle used by UVM
    virtual ALU_if vif = vif_inst;

    // Connects the DUT to the interface - USE vif_inst, NOT vif!
    ALUDecoder dut(
        .ALUop(vif_inst.sig_ALUop),
        .funct3(vif_inst.sig_funct3),
        .funct7b5(vif_inst.sig_funct7b5),
        .op(vif_inst.sig_op),
        .ALUControl(vif_inst.ALUControl)
    );

    initial begin
        // Register the interface globally for UVM components
        uvm_resource_db #(virtual ALU_if)::set(.scope("*"), .name("ALU_if"), .val(vif));

        // Start the UVM test
        run_test();
    end
endmodule
