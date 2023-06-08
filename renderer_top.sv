module renderer_top(
                input               CLOCK_50,
                input        [3:0]  KEY,
                input        [11:0]  SW,
                output logic [7:0]  LEDR,
                output logic [6:0]  HEX0, HEX1,
                // VGA Interface
                output logic [7:0]  VGA_R,        //VGA Red
                                    VGA_G,        //VGA Green
                                    VGA_B,        //VGA Blue
                output logic        VGA_CLK,      //VGA Clock
                                    VGA_SYNC_N,   //VGA Sync signal
                                    VGA_BLANK_N,  //VGA Blank signal
                                    VGA_VS,       //VGA virtical sync signal
                                    VGA_HS       //VGA horizontal sync signal

);

    parameter WIIA = 4; // integer bits for angle
    parameter WIFA = 8; // decimal bits for angle
    parameter WI = 8;   // integer bits for triangle data
    parameter WF = 8;   // decimal bits for triangle data

    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;

    logic Reset, Clk;
    logic frame_clk;
    logic frame_clk_rising_edge;
    logic load_obj, load_done;
    logic draw_start, draw_done, proj_start, proj_done, clear_start, clear_done, frame_done;
    logic [23:0]draw_data;
	logic [23:0]read_data;
    logic fifo_r, fifo_w, list_r, list_w;
    logic fifo_empty, fifo_full, list_empty, list_full, list_read_done;
    logic [9:0] draw_DrawX, draw_DrawY, clear_DrawX, clear_DrawY;
    logic [9:0] DrawX, DrawY;
    logic [9:0] ReadX, ReadY;
    logic [2:0][1:0][9:0] proj_triangle_out, proj_triangle_in;
    logic [2:0][2:0][(WI+WF)-1:0] orig_triangle_in, orig_triangle_out;
	 logic [5:0] out1;

    logic [7:0]           keycode;
    logic [WI+WF-1:0]     x_pos, y_pos, z_pos;
    logic [WIIA+WIFA-1:0] alpha, beta, gamma;
	logic [2:0][35:0]  proj_vertex;
	logic [23:0]	draw_color;
	logic [2:0] initial_rst  = 0;
	logic [4:0][2:0][35:0] all_proj_vertex;
    assign Clk = CLOCK_50;
	 
	 logic [5:0][5:0] para_out;
	 
    always_ff @ (posedge Clk) begin
		
		if(initial_rst == 3'd7)
			initial_rst <= 3'd7;
		else
			initial_rst <= initial_rst + 1;
			
        Reset <= (initial_rst > 0 && initial_rst <5 )? 1'b1 : ~(KEY[0]);        // The push buttons are active low
    end

    assign frame_clk = VGA_VS;
    assign LEDR = SW;

    // generate VGA clk 25MHz
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));

    // VGA controller
    VGA_controller vga_controller_instance(
                                            .Clk(Clk),
                                            .Reset(Reset),
                                            .VGA_HS(VGA_HS),
                                            .VGA_VS(VGA_VS),
                                            .VGA_CLK(VGA_CLK),
                                            .VGA_BLANK_N(VGA_BLANK_N),
                                            .VGA_SYNC_N(VGA_SYNC_N),
                                            .ReadX(ReadX),
                                            .ReadY(ReadY)
    );

    // map color
    /*color_mapper color_instance(
                                .is_pixel(read_data),
                                .ReadX(ReadX),
                                .ReadY(ReadY),
                                .VGA_R(VGA_R),
                                .VGA_G(VGA_G),
                                .VGA_B(VGA_B)
    );*/

    // control the motion of the object and camera
    display #(.WI(WI), .WF(WF)) play(
                    .Clk(Clk),
                    .Reset(Reset),
                    .keycode(keycode),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .alpha(alpha),
                    .beta(beta),
                    .gamma(gamma),
                    .x(x_pos),
                    .y(y_pos),
                    .z(z_pos)
    );

    // control unit for every module
    control_unit cu(
                    .Clk(Clk),
                    .Reset(Reset),
                    .frame_clk(frame_clk),
                    .draw_done(draw_done),
                    .clear_done(clear_done),
                    .load_done(load_done),
					.draw_color(draw_color),
                    .draw_DrawX(draw_DrawX),
                    .draw_DrawY(draw_DrawY),
                    .clear_DrawX(clear_DrawX),
                    .clear_DrawY(clear_DrawY),
                    .load_obj(load_obj),
                    .draw_start(draw_start),
                    .clear_start(clear_start),
                    .proj_start(proj_start),
                    .draw_data(draw_data),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .frame_done(frame_done)
    );

    // module to clear frame
    clear_frame cf(
                    .Clk(Clk),
                    .Reset(Reset),
                    .clear_frame_start(clear_start),
                    .DrawX(clear_DrawX),
                    .DrawY(clear_DrawY),
                    .clear_frame_done(clear_done)
    );

    // module to draw projected triangles in screen space
    draw draw_instance(
                        .Clk(Clk),
                        .Reset(Reset),
                        .draw_start(draw_start),
                        .triangle_data(proj_triangle_out),
						.all_proj_vertex(all_proj_vertex),
						.para_out(para_out),
						//.out1(out1),
                        .fifo_empty(fifo_empty),
                        .fifo_r(fifo_r),
                        .DrawX(draw_DrawX),
                        .DrawY(draw_DrawY),
						.draw_color(draw_color),
                        .draw_done(draw_done)
    );

    // module to project original triangle in 3D space into 2D screen space
    project #(.WIIA(WIIA), .WIFA(WIFA), .WI(WI), .WF(WF)) project_instance(
                                                                    .Clk(Clk),
                                                                    .Reset(Reset),
                                                                    .proj_start(proj_start),
                                                                    .orig_triangle(orig_triangle_out),
																	.frame_done(frame_done),
                                                                    .alpha(alpha),
                                                                    .beta(beta),
                                                                    .gamma(gamma),
                                                                    .x_translate(x_pos),
                                                                    .y_translate(y_pos),
                                                                    .z_translate(z_pos),
                                                                    .list_read_done(list_read_done),
                                                                    .proj_triangle(proj_triangle_in),
                                                                    .list_r(list_r),
                                                                    .fifo_w(fifo_w),
                                                                    .proj_done(proj_done),
																	.all_proj_vertex_out(all_proj_vertex),
																	//.out1(out1)
																	.para_out(para_out)
    );

    // triangle fifo
    // store projected triangles (in 2D screen space) for every frame
    triangle_fifo #(.Waddr(6), .size(60)) tf(
                                    .Clk(Clk),
                                    .Reset(Reset),
                                    .r_en(fifo_r),
                                    .w_en(fifo_w),
                                    .triangle_in(proj_triangle_in),
                                    .triangle_out(proj_triangle_out),
                                    .is_empty(fifo_empty),
                                    .is_full(fifo_full)
    );

    // fifo_writer fw(
    //                 .Clk(Clk),
    //                 .Reset(Reset),
    //                 .clear_start(clear_start),
    //                 .fifo_w(fifo_w),
    //                 .proj_triangle_in(proj_triangle_in)
    // );

    triangle_list #(.WI(WI), .WF(WF), .Waddr(6), .size(60)) tl(
                                                                .Clk(Clk),
                                                                .Reset(Reset),
                                                                .r_en(list_r),
                                                                .w_en(list_w),
                                                                .triangle_in(orig_triangle_in),
                                                                .triangle_out(orig_triangle_out),
                                                                .is_empty(list_empty),
                                                                .is_full(list_full),
                                                                .read_done(list_read_done)
    );

    // way1 to load model
    // should be commented when use txt file to load model
    // write original triangle data into triangle list
    list_writer #(.WI(WI), .WF(WF)) lw(
                                        .Clk(Clk),
                                        .Reset(Reset),
                                        .load_obj(load_obj),
                                        .list_w(list_w),
                                        .load_done(load_done),
                                        .orig_triangle_in(orig_triangle_in)
    );

    frame_buffer fb(
                    .Clk(Clk),
                    .Reset(Reset),
					.clear_start(clear_start),
                    .frame_clk_rising_edge(frame_clk_rising_edge),
                    .DrawX(DrawX),
                    .DrawY(DrawY),
                    .draw_data(draw_data),
                    .frame_done(frame_done),
                    .ReadX(ReadX),
                    .ReadY(ReadY),
                    .read_data({VGA_R,VGA_G,VGA_B})
    );
	
	keyboard k1( .Clk(Clk),
                 .Reset(Reset),
                 .SW(SW),
                 .keycode(keycode)
                );

    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);

endmodule
