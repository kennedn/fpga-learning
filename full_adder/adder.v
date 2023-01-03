
module and_gate (input [3:0] pmod, output [4:0] led);
    // Define wires that will connect both parts of the full adder
    wire [1:0] carry_and_1;
    wire [1:0] carry_or;
    wire [1:0] carry_and_2;
    
    // Create wire that routes both inputs A and B
    assign carry_and_1 = pmod[1:0];
    // Create a wire that routes {A ^ B, C}
    assign carry_and_2 = {~pmod[0] ^ ~pmod[1], ~pmod[2]};
    // Create a wire that routes the AND of carry_and_1[1:0] and carry_and_2[1:0]
    assign carry_or = {~carry_and_1[1] & ~carry_and_1[0],  carry_and_2[0] & carry_and_2[1]};
    // Carry bit, assign the OR of carry_or[1:0] to led_3
    assign led[4] = carry_or[0] | carry_or[1];
    // Sum bit, assign the XOR of carry_and_2[1:0]
    assign led[2] = carry_and_2[0] ^ carry_and_2[1];
endmodule