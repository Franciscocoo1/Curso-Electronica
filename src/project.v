/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */
`default_nettype none

module tt_um_sensores (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       ena,

    input  wire [7:0] ui_in,
    output reg  [7:0] uo_out,

    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe
);

    // INPUTS
    // IN0 = Engine ON (LSB)
    // IN1 = High temperature
    // IN2 = Low oil pressure
    // IN3 = Low coolant

    wire engine_on   = ui_in[0];
    wire temp_high   = ui_in[1];
    wire oil_low     = ui_in[2];
    wire coolant_low = ui_in[3];

    // Bidirectional pins unused
    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    reg [2:0] code;
    reg led_green;
    reg led_yellow;
    reg led_red;
    reg led_blue;
    reg buzzer;

    always @(*) begin

        // Default: all outputs OFF
        code       = 3'b000;
        led_green  = 1'b0;
        led_yellow = 1'b0;
        led_red    = 1'b0;
        led_blue   = 1'b0;
        buzzer    = 1'b0;

        if (engine_on) begin
            case ({temp_high, oil_low, coolant_low})

                // NORMAL
                3'b000: begin
                    code = 3'b000;
                    led_green = 1'b1;
                end

                // HIGH TEMPERATURE
                3'b100: begin
                    code = 3'b001;
                    led_yellow = 1'b1;
                end

                // LOW OIL
                3'b010: begin
                    code = 3'b010;
                    led_yellow = 1'b1;
                end

                // LOW COOLANT
                3'b001: begin
                    code = 3'b011;
                    led_yellow = 1'b1;
                    led_blue = 1'b1;
                end

                // TEMPERATURE + COOLANT
                3'b101: begin
                    code = 3'b100;
                    led_yellow = 1'b1;
                    led_blue = 1'b1;
                end

                // OIL + COOLANT
                3'b011: begin
                    code = 3'b101;
                    led_yellow = 1'b1;
                    led_blue = 1'b1;
                end

                // TEMPERATURE + OIL (CRITICAL)
                3'b110: begin
                    code = 3'b110;
                    led_red = 1'b1;
                    buzzer = 1'b1;
                end

                // ALL FAULTS
                3'b111: begin
                    code = 3'b111;
                    led_red = 1'b1;
                    led_blue = 1'b1;
                    buzzer = 1'b1;
                end

            endcase
        end

        // OUTPUT MAPPING
        // OUT0 = Green LED
        // OUT1 = Yellow LED
        // OUT2 = Red LED
        // OUT3 = Blue LED
        // OUT4 = Buzzer
        // OUT5 = CODE0
        // OUT6 = CODE1
        // OUT7 = CODE2

        uo_out = {
            code[2],       // OUT7
            code[1],       // OUT6
            code[0],       // OUT5
            buzzer,        // OUT4
            led_blue,      // OUT3
            led_red,       // OUT2
            led_yellow,    // OUT1
            led_green      // OUT0
        };

    end

endmodule

`default_nettype wire
