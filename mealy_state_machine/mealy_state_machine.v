module mealy_state_machine(
    input              clock,
    input              reset_button,
    input              go_button,
    output reg  [3:0]  led,
    output reg         done_sig
);
    localparam STATE_IDLE     = 2'd0;
    localparam STATE_COUNTING = 2'd1;

    localparam HALF_DIVISOR   = 24'd1500000;
    localparam DIVISOR        = HALF_DIVISOR * 2;
    localparam LED_MAX        = 4'hf;

    wire       reset;
    wire       go;

    reg        div_clock;
    reg [1:0]  state;
    reg [23:0] clock_counter;

    assign reset = ~reset_button;
    assign go = ~go_button;

    always @(posedge clock or posedge reset) begin
        if (reset == 1'b1) begin
            clock_counter <= 24'b0;
        end else begin
            clock_counter <= (clock_counter + 1) % DIVISOR;
            div_clock <= (clock_counter < HALF_DIVISOR) ? 1'b1: 1'b0;
        end
    end

    always @(posedge div_clock or posedge reset) begin
        if (reset == 1'b1) begin
            state <= STATE_IDLE;
        end else begin
            case(state)
                STATE_IDLE: begin
                    done_sig <= 1'b0;
                    if (go == 1'b1) begin
                        state <= STATE_COUNTING;
                    end
                end
                STATE_COUNTING: begin
                    if (led == LED_MAX) begin
                        state <= STATE_IDLE;
                        done_sig <= 1'b1;
                    end
                end
                default: state <= STATE_IDLE;
            endcase
        end
    end

    always @(posedge div_clock or posedge reset) begin
        if (reset == 1'b1) begin
            led <= 4'b0;
        end else begin
            if (state == STATE_COUNTING) begin
                led <= led + 1'b1;
            end else begin 
                led <= 4'b0;
            end
        end
    end

endmodule
