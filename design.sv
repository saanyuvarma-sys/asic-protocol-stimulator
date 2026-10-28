
module uart_rx #(
    parameter CLKS_PER_BIT = 16
)(
    input wire clk,
    input wire rst,
    input wire rx,
    output reg [7:0] rx_data,
    output reg rx_done
);

    localparam IDLE      = 2'd0;
    localparam START_BIT = 2'd1;
    localparam DATA_BITS = 2'd2;
    localparam STOP_BIT  = 2'd3;

    reg [1:0] state = IDLE;
    reg [7:0] data_reg;
    integer clk_count;
    integer bit_index;

    always @(posedge clk) begin
        if (rst) begin
            state     <= IDLE;
            rx_data   <= 8'd0;
            rx_done   <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
            data_reg  <= 8'd0;
        end else begin
            rx_done <= 1'b0;

            case (state)
                IDLE: begin
                    clk_count <= 0;
                    bit_index <= 0;

                    if (rx == 1'b0)
                        state <= START_BIT;
                end

                START_BIT: begin
                    if (clk_count == (CLKS_PER_BIT/2 - 1)) begin
                        if (rx == 1'b0) begin
                            clk_count <= 0;
                            state <= DATA_BITS;
                        end else begin
                            state <= IDLE;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                DATA_BITS: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        clk_count <= 0;
                        data_reg[bit_index] <= rx;

                        if (bit_index == 7) begin
                            bit_index <= 0;
                            state <= STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 1;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STOP_BIT: begin
                    if (clk_count == CLKS_PER_BIT - 1) begin
                        rx_data <= data_reg;
                        rx_done <= 1'b1;
                        clk_count <= 0;
                        state <= IDLE;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
