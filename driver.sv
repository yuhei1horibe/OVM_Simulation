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

`ifndef DRV_GUARD
`define DRV_GUARD

`ifdef INCA
  `include "ovm.svh"
`else
  `include "ovm_macros.svh"
  import ovm_pkg::*;
`endif

`include "interface.sv"
`include "transaction.sv"

`define DRIV_IF pwm_vif.DRIVER.driver_cb

class pwm_driver extends ovm_driver #(pwm_transaction);
    `ovm_component_utils(pwm_driver)

    virtual pwm_intf pwm_vif;

    // Constructor
    function new (string name, ovm_component parent);
        super.new(name, parent);
        ovm_report_info("", "Driver instantiation");
    endfunction

    // Reset task
    task reset();
        wait(!pwm_vif.DRIVER.reset);
        `DRIV_IF.pwm_value  <= 8'h00;
        `DRIV_IF.pwm_range  <= 8'hFF;
        `DRIV_IF.pwm_en     <= 0;
        wait(pwm_vif.DRIVER.reset);
    endtask

    // Drive the transaction itemst to interface signals
    virtual task run();
        int count;

        // Get configuration
        // If there isn't, use default
        if(!get_config_int("iterations", count)) begin
            count = 256;
        end

        repeat(count) begin
            pwm_transaction trans;
            #256

            `DRIV_IF.pwm_en <= 1'b1;

            // Get new transaction
            seq_item_port.get_next_item(trans);

            ovm_report_info("", $psprintf("PWM value: %d, PWM range: %d", `DRIV_IF.pwm_value, `DRIV_IF.pwm_range));
            //@(posedge pwm_vif.DRIVER.clk); begin
            `DRIV_IF.pwm_value <= trans.pwm_value;
            `DRIV_IF.pwm_range <= trans.pwm_range;
            //end
        end
    endtask
endclass
`endif
