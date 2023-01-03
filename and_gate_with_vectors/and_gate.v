// button 0 lights up 2 LEDs, button 0 and 1 light up a 3rd

module and_gate (input [3:0] pmod, output [4:0] led);
    // Wire (net) declarations
    wire not_pmod_0;

    // Connect button 0 and LED's 0-4 to the net not_pmod_0
    assign not_pmod_0 = ~pmod[0];
    assign led[3:0] = {4{not_pmod_0}};

    // assign the result of not_pmod_0 AND NOT pmod[1] to led[2]
    assign led[4] = not_pmod_0 & ~pmod[1];
endmodule