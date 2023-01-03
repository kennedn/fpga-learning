// Define timescale for sim : <time_unit> / <time_precision>
`timescale 1ns / 10ps

// Define testbench

module clock_divider_tb();

    wire out;

    reg clock = 0;
    reg reset = 0;

    // Run for 1ns * 10000 = 10us
    localparam DURATION = 10000;

    // Generate clock: 1 / ((2 * 41.67) * 1ns) = 12Mhz
    always begin
        // Delay for 41.67 time units
        // 10ps precision means that 41.667 is rounded to 41.67ns
        # 41.667
        clock = ~clock;
    end

    // Instansiate module to test
    clock_divider #(.DIVISOR(6)) uut (
        .clock(clock),
        .reset(reset),
        .out(out)
    );

    // Pulse reset line high to begin
    initial begin
        #10
        reset = 1'b1;
        #1
        reset = 1'b0;
    end

    // Run Simulation (output to .vcd file)
    initial begin
        $dumpfile("clock_divider_tb.vcd");
        $dumpvars(0, clock_divider_tb);
        // Wait for Sim to complete
        #(DURATION)

        // Notify and end sim
        $display("Finished");
        $finish;
    end
endmodule