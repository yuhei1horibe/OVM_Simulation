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

`ifndef ENV_GUARD
`define ENV_GUARD

`ifdef INCA
  `include "ovm.svh"
`else
  `include "ovm_macros.svh"
  import ovm_pkg::*;
`endif

`include "sequencer.sv"
`include "driver.sv"

// Environment has generator, transaction
// and mailbox and connects those 2 blocks
// 
class pwm_env extends ovm_env;
    `ovm_component_utils(pwm_env)

    // Generator and Driver instances
    pwm_sequencer  sequencer;
    pwm_driver     driver;

    // Constructor
    function new (string name = "pwm_env", ovm_component parent = null);
        super.new(name, parent);
        ovm_report_info("", "Environment instantiated");
    endfunction

    // Instantiation of member variables
    virtual function void build;
        super.build();
        ovm_report_info("", "Instantiating sequencer and driver");

        driver    = pwm_driver::type_id::create("pwm_driver", this);
        sequencer = pwm_sequencer::type_id::create("pwm_sequencer", this);
    endfunction

    // Make connection between driver and sequencer
    virtual function void connect;
        ovm_report_info("", "Making connection between driver and sequencer");
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

    task run();
        driver.reset();
        ovm_report_info("", "Running test");
    endtask

    virtual function void report;
        ovm_report_info("", "Making report");
    endfunction
endclass
`endif
