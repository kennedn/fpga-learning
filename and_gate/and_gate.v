// When button 0 and 1 are pressed, turn on LED

module and_gate (input pmod_0, input pmod_1, output led_0);
    // Assign inverted AND of pmod_0 and pmod_1 to led_0
    assign led_0 = ~pmod_0 & ~pmod_1;
endmodule