module button_counter(
    input      [1:0] pmod,
    output reg [4:0] led
);
    wire reset;
    wire clock;

    assign reset = ~pmod[0];
    assign clock = ~pmod[1];

    // Execute on rising edge of clock or reset
    always @ (posedge clock or posedge reset) begin
        // Reset LED's to 0 if reset button pressed
        if (reset == 1'b1) begin
            led <= 5'b0;
        // Else add 1 to LED 
        end else begin
            led <= led + 1'b1;
        end
    end
endmodule