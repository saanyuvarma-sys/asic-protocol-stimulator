

`timescale 1ns/1ps

module uart_rx #(
    parameter CLKS_PER_BIT = 16
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,

    output reg  [7:0] data_out,
    output reg        rx_done,
    output reg        framing_error
);

    // FSM states
    localparam IDLE      = 2'b00;
    localparam START_BIT = 2'b01;
    localparam DATA_BITS = 2'b10;
    localparam STOP_BIT  = 2'b11;

    reg [1:0] state;
    reg [7:0] data_buffer;
    reg [3:0] bit_index;
    reg [15:0] clock_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state         <= IDLE;
            clock_count   <= 0;
            bit_index     <= 0;
            data_buffer   <= 0;
            data_out      <= 0;
            rx_done       <= 0;
            framing_error <= 0;
        end else begin

            // Default pulse signals
            rx_done       <= 0;
            framing_error <= 0;

            case (state)

                // Wait for start bit
                IDLE: begin
                    clock_count <= 0;
                    bit_index   <= 0;

                    if (rx == 0)
                        state <= START_BIT;
                end

                // Validate start bit at its midpoint
                START_BIT: begin
                    if (clock_count == (CLKS_PER_BIT / 2) - 1) begin
                        if (rx == 0) begin
                            clock_count <= 0;
                            state <= DATA_BITS;
                        end else begin
                            state <= IDLE;
                        end
                    end else begin
                        clock_count <= clock_count + 1;
                    end
                end

                // Receive 8 data bits, LSB first
                DATA_BITS: begin
                    if (clock_count == CLKS_PER_BIT - 1) begin
                        clock_count <= 0;
                        data_buffer[bit_index] <= rx;

                        if (bit_index == 7)
                            state <= STOP_BIT;
                        else
                            bit_index <= bit_index + 1;
                    end else begin
                        clock_count <= clock_count + 1;
                    end
                end

                // Check stop bit
                STOP_BIT: begin
                    if (clock_count == CLKS_PER_BIT - 1) begin
                        clock_count <= 0;

                        if (rx == 1) begin
                            data_out <= data_buffer;
                            rx_done  <= 1;
                        end else begin
                            framing_error <= 1;
                        end

                        state <= IDLE;
                    end else begin
                        clock_count <= clock_count + 1;
                    end
                end

            endcase
        end
    end

endmodule
