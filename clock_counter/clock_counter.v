module button_counter(
    input      clock,
    input      [3:0] pmod,
    output reg [4:0] led
);
    reg div_clock;
    // Create a counter and initialize to 0
    reg[27:0] counter = 28'd0;
    // Create a divisor constant of 4mhz which will result in a 6hz output (12mhz / (4mhz / 2))
    parameter DIVISOR = 28'd4000000;
    // Clock is HIGH 50% and LOW 50%, so we need a mid point
    parameter HALF_DIVISOR = DIVISOR / 2;

    always @(posedge clock) begin
        // Add 1 to counter, wrapping to 0 when DIVISOR is reached
        counter <= (counter + 28'd1) % DIVISOR;
        // Set div_clock HIGH if we are in the first half of our count, else set LOW
        div_clock <= (counter < HALF_DIVISOR) ? 1'b1 : 1'b0;
    end

    wire reset;
    assign reset = ~pmod[0];

    // Execute on rising edge of clock or reset
    always @ (posedge div_clock or posedge reset) begin
        // Reset LED's to 0 if reset button pressed
        if (reset == 1'b1) begin
            led <= 5'b0;
        // Else add 1 to LED 
        end else begin
            led <= led + 1'b1;
        end
    end
endmodule