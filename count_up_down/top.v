module top(
    input clock,
    input reset,
    output [4:0] led
);
    wire reset_wire;

    assign reset_wire = ~reset;

    wire div_clock;
    wire       next_up;
    wire       next_down;
    wire [4:0] led_out_1;
    wire [4:0] led_out_2;
    reg        init_go;

    reg        last_dir;


    clock_divider #(.DIVISOR(1200000)) divider_1 (
        .clock(clock),
        .reset(~reset),
        .out(div_clock)
    );

    always @ (posedge div_clock or posedge reset_wire) begin
        if (reset_wire == 1'b1) begin
            init_go <= 1'b1;
        end else begin
            init_go <= 1'b0;
        end
    end

    counter count_up (
        .clock(div_clock),
        .reset(~reset),
        .go(next_down | init_go),
        .led_out(led_out_1),
        .next(next_up)
    );

    counter #(.BACKWARDS(1'b1)) count_down (
        .clock(div_clock),
        .reset(~reset),
        .go(next_up),
        .led_out(led_out_2),
        .next(next_down)
    );
    
    assign led = led_out_1 ^ led_out_2;
endmodule