module top(
    input clock,
    input reset,
    output [4:0] led
);
    wire reset_wire;

    assign reset_wire = ~reset;

    wire divider_1_out;

    clock_divider divider_1 (
        .clock(clock),
        .reset(~reset),
        .out(divider_1_out)
    );

    clock_divider #(.DIVISOR(3000000)) divider_2 (
        .clock(clock),
        .reset(~reset),
        .out(led[4])
    );

    assign led[3:0] = {5{divider_1_out}};
endmodule