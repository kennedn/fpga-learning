module clock_divider #(
    parameter [5:0]  COUNT_WIDTH = 24,
    // Create a default divisor constant of 6mhz which will result in a delay of 500ms per cycle (1 / (12mhz / 6mhz))
    parameter [COUNT_WIDTH:0] DIVISOR = 6000000
)(
    input clock,
    input reset,
    output reg out
);
    // Clock is HIGH 50% and LOW 50%, so we need to double to get the divisor
    localparam DOUBLE_DIVISOR  = DIVISOR * 2;
    // Create a counter and initialize to 0
    reg [COUNT_WIDTH:0] counter = 0;


    always @(posedge clock) begin
        if (reset == 1'b1) begin
            counter <= 0;
            out <= 1'b0;
        end else begin
            // Add 1 to counter, wrapping to 0 when DIVISOR is reached
            counter <= ((counter + 1) % DOUBLE_DIVISOR);
            // Set div_clock HIGH if we are in the first half of our count, else set LOW
            out <= (counter < DIVISOR) ? 1'b1 : 1'b0;
        end
    end
endmodule
