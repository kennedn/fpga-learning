module counter #(
    parameter BACKWARDS = 1'b0
)(
    input            clock,
    input            go,
    input            reset,
    output reg       next,
    output reg [4:0] led_out
);

    localparam STATE_IDLE = 2'd0;
    localparam STATE_START = 2'd1;
    localparam STATE_DONE = 2'd2;
    localparam TARGET = (BACKWARDS) ? 5'd1 : 5'd31;

    reg [1:0] state;
    reg done = 1'b0;

    // Execute on rising edge of clock or reset
    always @ (posedge clock or posedge reset) begin
        // Reset LED's to 0 if reset button pressed
        if (reset == 1'b1) begin
            state <= STATE_IDLE;
            next <= 1'b0;
        // Else add 1 to LED 
        end else begin
            case(state)
                STATE_IDLE: begin
                    next <=1'b0;
                    if (go == 1'b1 && done == 1'b0) begin
                        state <= STATE_START;
                    end
                end
                STATE_START: begin
                    if (done == 1'b1) state <= STATE_DONE;
                end
                STATE_DONE: begin
                    next <= 1'b1;
                    state <= STATE_IDLE;
                end
                default: state <= STATE_IDLE;
            endcase
        end
    end

    always @(posedge clock or posedge reset) begin
        if (reset == 1'b1) begin
            led_out <= 5'b0;
            done <= 1'b0;
        end else begin
            case(state)
                STATE_START: begin
                    if (done == 1'b0) begin
                        if (BACKWARDS == 1'b0) begin
                            led_out <= led_out + 1'b1;
                        end else begin
                            led_out <= led_out - 1'b1;
                        end
                        if (led_out == TARGET) begin
                            led_out <= 5'b0;
                            done <= 1'b1;
                        end
                    end else begin
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end
endmodule
