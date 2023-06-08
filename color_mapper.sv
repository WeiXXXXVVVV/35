module  color_mapper(   input               is_pixel,           // Whether current pixel should be drew
                                                                //   or background
                        input        [9:0]  ReadX, ReadY,       // Current pixel coordinates
                        output logic [7:0]  VGA_R, VGA_G, VGA_B // VGA RGB output
                    );
    
    logic [7:0] Red, Green, Blue;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
    always_comb
    begin
        if (is_pixel == 1'b1)
        begin
            Red = 8'h90;
            Green = 8'h90;
            Blue = 8'h90;
        end
        else
        begin
            // Background with nice color gradient
            Red = 8'h90;
            Green = 8'h90;
            Blue = 8'h90;
        end
    end
    
endmodule
