`timescale 1ns / 10ps

module button_counter_debounce_tb();
//     input            clock,
//     input      [1:0] pmod,
//     output reg [4:0] led
// );

    reg clock = 0;
    reg [1:0] pmod;
    reg [4:0] led;
    wire [4:0] led_wire;
    assign led_wire = led;
    // Run for 1ns * 10000 = 400us
    localparam DURATION = 400000;

    integer bounces;
    integer i;
    integer prev_inc;

    // Generate clock: 1 / ((2 * 41.67) * 1ns) = 12Mhz
    always begin
        // Delay for 41.67 time units
        // 10ps precision means that 41.667 is rounded to 41.67ns
        # 41.667
        clock = ~clock;
    end
    
    always begin
        #1000
        prev_inc = pmod[1];
        bounces = $urandom % 25 + 5;
        for (i = 0; i < bounces; i = i + 1) begin
            #($urandom % 10)
            pmod[1] = ~pmod[1];
        end
        pmod[1] = ~prev_inc;
    end

    button_counter_debounce #(.DIVISOR(3)) counter1 (
        .clock(clock),
        .pmod(pmod),
        .led(led_wire)
    );


    // Pulse reset line high to begin
    initial begin
        pmod[1] = 1'b1;
        #10
        pmod[0] = 1'b0;
        #1
        pmod[0] = 1'b1;
    end

    // Run Simulation (output to .vcd file)
    initial begin
        $dumpfile("button_counter_debounce_tb.vcd");
        $dumpvars(0, button_counter_debounce_tb);
        // Wait for Sim to complete
        #(DURATION)

        // Notify and end sim
        $display("Finished");
        $finish;
    end
endmodule