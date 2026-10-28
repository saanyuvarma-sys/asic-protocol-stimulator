
`timescale 1ns/1ps

module uart_tb;

    parameter CLKS_PER_BIT = 16;
    parameter BIT_PERIOD = 160;

    reg clk = 0;
    reg rst = 1;
    reg rx = 1;

    wire [7:0] rx_data;
    wire rx_done;

    integer pass_count = 0;
    integer fail_count = 0;
    integer i;

    uart_rx #(
        .CLKS_PER_BIT(CLKS_PER_BIT)
    ) dut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    always #5 clk = ~clk;

    task send_uart_byte;
        input [7:0] data;
        integer j;
        begin
            rx = 0;
            #(BIT_PERIOD);

            for (j = 0; j < 8; j = j + 1) begin
                rx = data[j];
                #(BIT_PERIOD);
            end

            rx = 1;
            #(BIT_PERIOD);
        end
    endtask

    task test_byte;
        input [7:0] expected;
        begin
            send_uart_byte(expected);

            // Wait for the receiver to finish
            wait (rx_done == 1'b1);
            #1;

            if (rx_data === expected) begin
                $display("PASS: Expected=%h Received=%h",
                         expected, rx_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: Expected=%h Received=%h",
                         expected, rx_data);
                fail_count = fail_count + 1;
            end

            @(negedge clk);
            #10;
        end
    endtask

    initial begin
        $dumpfile("uart_wave.vcd");
        $dumpvars(0, uart_tb);

        repeat (5) @(negedge clk);
        rst = 0;

        repeat (5) @(negedge clk);

        test_byte(8'hA5);
        test_byte(8'h3C);
        test_byte(8'h55);
        test_byte(8'hFF);
        test_byte(8'h00);

        $display("-------------------------");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("-------------------------");

        $finish;
    end

    initial begin
        #20000;
        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule
