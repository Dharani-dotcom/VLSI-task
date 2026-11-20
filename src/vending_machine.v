`timescale 1ns / 1ps

module vending_machine (
    input wire clk,              // 100 MHz onboard clock (Artix-7)
    input wire rst,              // Active-high reset (Button)
    input wire coin_5,           // ₹5 coin input (Button)
    input wire coin_10,          // ₹10 coin input (Button)
    output reg dispense,         // LED indicator: Item dispensed
    output reg change_5,         // LED indicator: ₹5 change returned
    output reg [1:0] state_led   // LEDs showing current balance state
);

    // State Encoding (Current Balance)
    parameter S0  = 2'b00; // ₹0
    parameter S5  = 2'b01; // ₹5
    parameter S10 = 2'b10; // ₹10

    reg [1:0] current_state, next_state;

    // Edge detection registers for clean single-cycle button triggers
    reg coin_5_d, coin_10_d;
    wire coin_5_pulse, coin_10_pulse;

    always @(posedge clk) begin
        if (rst) begin
            coin_5_d  <= 1'b0;
            coin_10_d <= 1'b0;
        end else begin
            coin_5_d  <= coin_5;
            coin_10_d <= coin_10;
        end
    end

    // Rising-edge detection
    assign coin_5_pulse  = coin_5  & ~coin_5_d;
    assign coin_10_pulse = coin_10 & ~coin_10_d;

    // State Register
    always @(posedge clk) begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next-State and Output Logic
    always @(*) begin
        // Default assignments to prevent latches
        next_state = current_state;
        dispense   = 1'b0;
        change_5   = 1'b0;
        state_led  = current_state;

        case (current_state)
            S0: begin
                if (coin_5_pulse)
                    next_state = S5;
                else if (coin_10_pulse)
                    next_state = S10;
            end

            S5: begin
                if (coin_5_pulse)
                    next_state = S10;
                else if (coin_10_pulse) begin
                    next_state = S0;
                    dispense   = 1'b1; // ₹5 + ₹10 = ₹15 (Dispense)
                end
            end

            S10: begin
                if (coin_5_pulse) begin
                    next_state = S0;
                    dispense   = 1'b1; // ₹10 + ₹5 = ₹15 (Dispense)
                end else if (coin_10_pulse) begin
                    next_state = S0;
                    dispense   = 1'b1; // ₹10 + ₹10 = ₹20 (Dispense + ₹5 Change)
                    change_5   = 1'b1;
                end
            end

            default: next_state = S0;
        endcase
    end

endmodule
