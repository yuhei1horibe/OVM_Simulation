//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2019 04:51:20 PM
// Design Name: 
// Module Name: PWM_UNIT_TEST
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`ifndef GEN_GUARD
`define GEN_GUARD

`ifdef INCA
  `include "ovm.svh"
`else
  `include "ovm_macros.svh"
  import ovm_pkg::*;
`endif

`include "transaction.sv"

// Sequencer will generate transactions,
// and pass it to driver
class pwm_sequencer extends ovm_sequencer #(pwm_transaction);
    `ovm_sequencer_utils(pwm_sequencer)

    function new (string name = "pwm_sequencer", ovm_component parent);
        super.new(name, parent);
        `ovm_update_sequence_lib_and_item(pwm_transaction)
    endfunction
endclass
`endif
