module button_counter_debounce #(
    parameter DIVISOR = 24'd120000
)(
    input            clock,
    input      [1:0] pmod,
    output reg [4:0] led
);
    wire reset;
    wire button;

    assign reset = ~pmod[0];
    assign button = ~pmod[1];

    localparam STATE_IDLE = 2'd0;
    localparam STATE_PRESSED = 2'd1;
    localparam STATE_DONE = 2'd2;

    // Clock pulse every 100ms (1/(12mhz / 1.2mhz))
    localparam DOUBLE_DIVISOR        = DIVISOR * 2;


    reg        state;
    reg        div_clock;
    reg [23:0] clock_counter;
    reg        led_done;

    always @(posedge clock or posedge reset) begin
        if (reset == 1'b1) begin
            clock_counter <= 24'b0;
        end else begin
            clock_counter <= (clock_counter + 1) % DOUBLE_DIVISOR;
            div_clock <= (clock_counter < DIVISOR) ? 1'b1: 1'b0;
        end
    end

    // Handle button debouncing
    always @ (posedge div_clock or posedge reset) begin
        // Reset LED's to 0 if reset button pressed
        if (reset == 1'b1) begin
            state <= STATE_IDLE;
        // Else add 1 to LED 
        end else begin
            case (state)
                STATE_IDLE: if (button == 1'b1) state <= STATE_PRESSED;
                STATE_PRESSED: if (button == 1'b0) state <= STATE_IDLE;
                default: state <= STATE_IDLE;
            endcase
        end
    end

    always @ (posedge clock or posedge reset) begin
        // Reset LED's to 0 if reset button pressed
        if (reset == 1'b1) begin
            led <= 5'b0;
            led_done <= 1'b0;
        end else begin  // Else add 1 to LED
            if (state == STATE_PRESSED && !led_done) begin
                led_done <= 1'b1;
                led <= led + 1'b1;
            end else if(state == STATE_IDLE) begin
                led_done <= 1'b0;
            end
        end
    end

endmodule