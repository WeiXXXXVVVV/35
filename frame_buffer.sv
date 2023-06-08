module frame_buffer
(
    input Clk,
    input Reset,
	input clear_start,
    input frame_clk_rising_edge,
    input [9:0] DrawX, DrawY,       // coordinates of drawing
    input [23:0]draw_data,
    input frame_done,               // high when drawing for a frame is finished
    input [9:0] ReadX, ReadY,       // coordinates of reading
    output logic [23:0]read_data
);

    logic rw, new_rw;               // read/write switch
    logic w_en1, w_en2;             // write enable
    logic [9:0] rx,ry;              // valid ReadX, ReadY (less than 639/479)
    logic [18:0] w_addr, r_addr;    // write/read addr
    logic [17:0] addr1, addr2;      // buffer addr
    logic [11:0]read_data1, read_data2;   // buffer read data
    logic [8:0]read_data_8;  
	
	
    ram buffer1(
				.address(addr1),
                .clock(Clk),
                .data({draw_data[23:20],draw_data[15:12],draw_data[7:4]}),
                .wren(w_en1),
                .q(read_data1)
    );
    
    ram buffer2(
				.address(addr2),
                .clock(Clk),
                .data({draw_data[23:20],draw_data[15:12],draw_data[7:4]}),
                .wren(w_en2),
                .q(read_data2)
    );
	/*ram buffer(
			.clock		(Clk),
			.data		({draw_data[23:21],draw_data[15:13],draw_data[7:5]}),
			.rdaddress	(r_addr),
			.rden		(1'b1),
			.wraddress	(w_addr),
			.wren		(w_en1),
			.q			(read_data_8)
	);*/
    
    // switch frame
    always_ff @ (posedge Clk)
    begin
        if (Reset) 
            rw <= 1'b0;
        else
            rw <= new_rw;
    end

    always_ff @ (posedge Clk)
    begin
        if (rw)            // write buffer 1, read buffer 2
        begin
            addr2 <= r_addr;
			addr1 <= w_addr;
			if((ReadY > 10'd79 ) && (ReadY < 10'd400) && (ReadX > 10'd114) && (ReadX < 10'd525))
				read_data <= {read_data2[11:8], 4'b0000,read_data2[7:4],4'b0000,read_data2[3:0],4'b0000};
            else
				read_data <= {24{1'b1}};
        end
        else   
        begin
            addr1 <= r_addr;
			addr2 <= w_addr;
            if((ReadY > 10'd79 ) && (ReadY < 10'd400) && (ReadX > 10'd114) && (ReadX < 10'd525))
				read_data <= {read_data1[11:8], 4'b0000,read_data1[7:4],4'b0000,read_data1[3:0],4'b0000};
            else
				read_data <= {24{1'b1}};
        end
    end
	/*always_ff @ (posedge Clk)
    begin
		
		if((ReadY > 10'd79 ) && (ReadY < 10'd400) && (ReadX > 10'd114) && (ReadX < 10'd525))
			read_data <= {read_data_8[8:6], 5'b00000,read_data_8[5:3],5'b00000,read_data_8[2:0],5'b00000};
		else
		
        read_data <= {24{1'b1}};
    end*/
    
	logic [9:0] DrawX_new, DrawY_new;	
	logic [9:0] ReadX_new, ReadY_new;	
    always_comb
    begin
        new_rw = rw;
        w_en1 = 1'b0;
        w_en2 = 1'b0;
        w_addr = DrawX_new + DrawY_new * 10'd410;
        r_addr = ReadX_new + ReadY_new * 10'd410;
		
		DrawY_new = (DrawY > 10'd79 ) ? ((DrawY > 10'd399)? 10'd322 : DrawY - 10'd80  ): 10'd322;
		DrawX_new = (DrawX > 10'd114) ? ((DrawX > 10'd524)? 10'd411 : DrawX - 10'd115 ): 10'd411;
        ReadY_new = (ReadY > 10'd79 ) ? ((ReadY > 10'd399)? 10'd0 : ReadY - 10'd80  ): 10'd0;
		ReadX_new = (ReadX > 10'd114) ? ((ReadX > 10'd524)? 10'd0 : ReadX - 10'd115 ): 10'd0;
	
		if(rw)
			w_en1 = (draw_data > 0)? 1'b1 : clear_start;
		else
			w_en2 = (draw_data > 0)? 1'b1 : clear_start;

        // keep the same frame if drawing does not finish
        if(frame_clk_rising_edge && frame_done)
            new_rw = !rw;
    end

endmodule
