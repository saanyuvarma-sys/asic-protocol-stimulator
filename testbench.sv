

`timescale 1ns/1ps

module uart_tb;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] data_out;
    wire rx_done;
    wire framing_error;

    parameter CLKS_PER_BIT = 16;
    parameter BIT_PERIOD = 160;

    // UART Receiver instantiation
    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done),
        .framing_error(framing_error)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Send UART frame with valid stop bit
    task send_valid_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // Send UART frame with invalid stop bit
    task send_invalid_stop_byte;
        input [7:0] data;
        integer i;
        begin
            rx = 0;
            #(BIT_PERIOD);

            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(BIT_PERIOD);
            end

            // Invalid stop bit
            rx = 0;
            #(BIT_PERIOD);

            // Return to idle
            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    // Test sequence
    initial begin
        rst = 1;
        rx = 1;

        #100;
        rst = 0;

        // Test 1: Valid data A5
        fork
            send_valid_byte(8'hA5);
            begin
                wait (rx_done == 1);
                #1;
                if (data_out === 8'hA5)
                    $display("PASS: Valid A5 received");
                else
                    $display("FAIL: A5 mismatch");
            end
        join

        // Test 2: Valid data 3C
        fork
            send_valid_byte(8'h3C);
            begin
                wait (rx_done == 1);
                #1;
                if (data_out === 8'h3C)
                    $display("PASS: Valid 3C received");
                else
                    $display("FAIL: 3C mismatch");
            end
        join

        // Test 3: Invalid stop bit
        fork
            send_invalid_stop_byte(8'h55);
            begin
                wait (framing_error == 1);
                #1;
                if (framing_error === 1)
                    $display("PASS: Framing error detected");
                else
                    $display("FAIL: Framing error not detected");
            end
        join

        #200;
        $display("Simulation completed.");
        $finish;
    end

    // Waveform generation
    initial begin
        $dumpfile("uart_wave.vcd");
        $dumpvars(0, uart_tb);
    end

    // Safety timeout
    initial begin
        #20000;
        $display("ERROR: Simulation timeout.");
        $finish;
    end

endmodule
