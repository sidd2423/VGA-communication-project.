module tv_pattern(
    input vga_clk, // Assuming a clock signal is available
    input slow_clk, // Slowed down clock from clkdiv module
    input [9:0] x,
    input [9:0] y,
    input [9:0] SW, // Switches input
    input KEY1, // Adding KEY1 as an input for controlling the square's movement
    output reg [3:0] red,
    output reg [3:0] green,
    output reg [3:0] blue);

    reg [9:0] square_x_position = 269;
    reg [9:0] square_y_position = 199; // Initial Y position of the square
    reg [9:0] square_width = 100; // Initial width of the square
    reg [9:0] square_height = 50; // Initial height of the square
    reg color_change_trigger = 0; // Trigger for changing color
    reg [3:0] current_red = 4'hF; // Initial color values
    reg [3:0] current_green = 4'hF;
    reg [3:0] current_blue = 4'hF;

    // Process for changing the square size
    always @(posedge slow_clk) begin
        if(SW[8] && !KEY1 && (square_width < 350) && (square_height < 200)) begin
            square_width <= square_width * 2;
            square_height <= square_height * 2;
        end
    end

    // Simple pseudo-random color generator
    always @(posedge slow_clk) begin
        if(SW[9] && !KEY1 && !color_change_trigger) begin
            // Generate new color values
            current_red <= current_red + 4'h1;
            current_green <= current_green + 4'h3;
            current_blue <= current_blue + 4'h2;
            // Ensure the color is not black
            if(current_red == 0 && current_green == 0 && current_blue == 0) begin
                current_red <= 4'h1;
            end
            color_change_trigger <= 1; // Set trigger to avoid continuous color change
        end else if (!(SW[9] && !KEY1)) begin
            color_change_trigger <= 0; // Reset trigger when condition is not met
        end
    end

    // Process to update square position
    always @(posedge slow_clk) begin
        if(SW[2] && !KEY1 && (square_y_position > 20)) begin
            square_y_position <= square_y_position - 20;
        end
        if(SW[1] && !KEY1 && (square_y_position > 20)) begin
            square_y_position <= square_y_position + 20;
        end
        if(SW[3] && !KEY1 && (square_x_position > 20)) begin
            square_x_position <= square_x_position - 20;
        end
        if(SW[0] && !KEY1 && (square_x_position > 20)) begin
            square_x_position <= square_x_position + 20;
        end
    end

    always @(posedge vga_clk) begin
        // Process to draw the square based on its current position and size
        if(x >= square_x_position && x < square_x_position + square_width && y >= square_y_position && y < square_y_position + square_height) begin
            red <= current_red;
            green <= current_green;
            blue <= current_blue;
        end else begin
            red <= 4'h0;
            green <= 4'h0;
            blue <= 4'h0;
        end
    end
endmodule
