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

`ifndef TOP_GUARD
`define TOP_GUARD

`ifdef INCA
  `include "ovm.svh"
`else
  `include "ovm_macros.svh"
  import ovm_pkg::*;
`endif

`include "interface.sv"
`include "environment.sv"

// Test bench top module
module pwm_test_top;

    // Clock and Reset
    bit clk;
    bit reset;
    bit enable;

    // Clock generation
    always #10 clk = ~clk;

    // Reset
    initial begin
        reset      = 0;
        enable     = 0;
        #50 reset  = 1;
        #10 enable = 1;
    end

    // Interface
    pwm_intf pwm_if(.clk(clk), .reset(reset));

    class pwm_test extends ovm_test;
        `ovm_component_utils(pwm_test)

        // Constructor
        function new(string name = "pwm_test", ovm_component parent = null);
            super.new(name, parent);
            ovm_report_info("", "Instantiation of top module");
        endfunction

        // Environment
        pwm_env env;

        virtual function void build();
            super.build();
            ovm_report_info("", "Instantiating environment");
            env = pwm_env::type_id::create("pwm_env", this);

            set_global_timeout(1ms);
            set_config_int("pwm_env", "iterations", 4096);
        endfunction

        virtual function void connect();
            ovm_report_info("", "Connecting driver and interface");

            // Connect virtual interface in driver to actual interface
            env.driver.pwm_vif = pwm_if;
        endfunction 

        //initial begin
        //    // Instantiation of environment
        //    env = new(intf);

        //    // Repeat count
        //    env.sequencer.repeat_count = 10;

        //    // Run test
        //    env.run();
        //end
    endclass

    pwm_test inst;

    // DUT instantiation
    PWM_UNIT PWM_DUT(
        .pwm_value  (pwm_if.pwm_value  ),
        .pwm_range  (pwm_if.pwm_range  ),
        .pwm_clk    (pwm_if.clk    ),
        .pwm_reset  (pwm_if.reset  ),
        //.pwm_en     (pwm_if.pwm_en     ),
        .pwm_en     (enable        ),

        .pwm_period (pwm_if.pwm_period ),
        .pwm_out    (pwm_if.pwm_out)
    );
    // Instantiation of test class

    // Wave dump
    initial begin
        inst = new();
        run_test();
        $dumpfile ("dump.vcd");
        $dumpvars;
    end
endmodule
`endif
