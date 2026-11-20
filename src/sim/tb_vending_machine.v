`timescale 1ns / 1ps

module tb_vending_machine;

    reg clk;
    reg rst;
    reg coin_5;
    reg coin_10;
    wire dispense;
    wire change_5;
    wire [1:0] state_led;

    // Instantiate Unit Under Test (UUT)
    vending_machine uut (
        .clk(clk),
        .rst(rst),
        .coin_5(coin_5),
        .coin_10(coin_10),
        .dispense(dispense),
        .change_5(change_5),
        .state_led(state_led)
    );

    // 100 MHz Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        coin_5 = 0;
        coin_10 = 0;

        // Release Reset
        #20 rst = 0;

        // Scenario 1: Insert ₹5 + ₹5 + ₹5 = ₹15 (Dispense, No Change)
        #10 coin_5 = 1; #10 coin_5 = 0;
        #20 coin_5 = 1; #10 coin_5 = 0;
        #20 coin_5 = 1; #10 coin_5 = 0;

        // Scenario 2: Insert ₹10 + ₹10 = ₹20 (Dispense + ₹5 Change)
        #30 coin_10 = 1; #10 coin_10 = 0;
        #20 coin_10 = 1; #10 coin_10 = 0;

        // Scenario 3: Insert ₹5 + ₹10 = ₹15 (Dispense, No Change)
        #30 coin_5 = 1;  #10 coin_5 = 0;
        #20 coin_10 = 1; #10 coin_10 = 0;

        #50 $finish;
    end

endmodule
