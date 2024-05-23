# VGA-communication-project.
The VGA communication between the VGA screen and the DE10 lite board involve the precise timings to control the signals to activate the pixels on the VGA screen.
Video demonstration here:
https://youtu.be/z2D0aYnsUdE

Introduction:

This project is a demonstration of a brand new concept which is digital signal output to a screen with an FPGA board with the VGA output on the DE10 board.. The VGA communication between the VGA screen and the DE10 lite board involve the precise timings to control the signals to activate the pixels on the VGA screen. The concept behind these VGA signals is to synchronise the movement of these signals across the screen to display images. The HSYNC and VSYNC signals that  sih_sync and v_sync are for synchronisation of the display, the RGB signals control the colour intensity of the pixels, and the clock signal will control the rate at which the pixel data is sent to the monitor. To create an image on the VGA display.


So according to the first specification we had to draw the 100 by 50 rectangle and we did this using the tv_pattern.v module in which we had to slow_clk which was created using a clock divider that converts the input 50MHz signal to 25MHz used for data synchronisation. 

To create the square we initialised the x and the y coordinates (as reg type variable) which makes it look at the centre of the screen, and then we initialised the width and the height of the square ( reg type) .  

For the second specification we initiated the vga_controller module provided to us in the top level file with KEY[0] as the input to the reset_n and setting everything to zero, such that it resets to a white rectangle. 

The tv_pattern module relies on the VGA clock signal (vga_clk) to synchronise its output with the display refresh cycle, indirectly interacting with the HSYNC and VSYNC signals managed by the vga_controller module.

Then we used a slow clock to synchronise the movement of the white rectangle, and the rectangle moves up, down, left and right using the SW[3:0] switches and KEY1 to move the rectangle by 20 pixels in the direction we set with the switches with an always block by  changing the value of the “x” and “y” positions of the rectangle and drawing the square using different triggers. To draw the rectangle continuously we use the position register with continuous procedural assignments to drive white colour using output registers(red,green,blue) with max values.

We used simple combinational logic to the show the error screen on the hex displays using the switches and to show the error screen on hex displays when the square hit the bounds of the screen we set the boundaries that are available to us which are 640 by 480 so if the square’s “x”  or “y” position (Pixel counters) goes beyond the active area, we get an “E. r.” message on the HEX1 and HEX2 displays.

Regarding the percentage of hardware resources utilised 248/49,760 total logic elements (<1%), 131 total registers, 87/360 total pins were used (24%), and the total amount of PLLs used were ¼ (25%) .

So we just use SW[9] and KEY[1] to change the colour of the rectangle randomly, while considering the trigger that forces it to change different colours to every other colour and not the black colour, while also setting the trigger such that it does not change it continuously but only when KEY[1] is pressed and to reset it to white once the condition is not met. We use registers to store the values of randomised colours. All the colours are combinations of values in RGB registers.

We use simple conditionals to increase the size of the rectangle inside an always block with square height and square width being doubled when SW8 and KEY[1] is pressed until it goes beyond the active area ( 640 by 480).
