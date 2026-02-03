// Drake Gonzales
// drgonzales@g.hmc.edu
// Top-level testbench for Extend UVM verification
`include "uvm_macros.svh"  
`include "Extend_if.sv"
`include "Extend.sv"
`include "Extend_pkg.sv"

module Extend_tb_top;
    import uvm_pkg::*;
    import Extend_pkg::*;

    // Real interface instance
    Extend_if vif_inst();

    // Virtual handle used by UVM
    virtual Extend_if vif = vif_inst;

    // Connects the DUT to the interface - USE vif_inst, NOT vif!
    Extend dut(
        .Instr(vif_inst.sig_Instr),
        .ImmSrc(vif_inst.sig_ImmSrc),
        .ImmExt(vif_inst.ImmExt)
    );

    initial begin
        // Register the interface globally for UVM components
        uvm_resource_db #(virtual Extend_if)::set(.scope("*"), .name("Extend_if"), .val(vif));

        // Start the UVM test
        run_test();
    end
endmodule
