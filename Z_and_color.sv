module Z_and_color (
	input [2:0][35:0] proj_vertex_in,
	input	[1:0]	set,
	input	[10:0] 	x,
					y,
	input [5:0] para_out,
    output	signed [19:0]	z,
	output	[23:0]	color
	
);
		//parameter point0, point1 , point2 , point3 ;
		logic [2:0][35:0] proj_vertex;
		assign proj_vertex = proj_vertex_in;
      //logic [5:0] ro;
		//assign ro =6'b001000;
		parameter point0 = {8'd123, 8'd60, 8'd80}, point1 = {8'd123, 8'd60, 8'd80}, point2 = {8'd123, 8'd60, 8'd80}, point3 = {8'd123, 8'd60, 8'd80};
		//parameter point0 = {8'd255, 8'd0, 8'd0}, point1 = {8'd0, 8'd255, 8'd0}, point2 = {8'd0, 8'd0, 8'd255}, point3 = {8'd255, 8'd255, 8'd0};
		logic signed [18:0] w0, w1, w2, area;
		logic [9:0] w0_area, w1_area, w2_area;
		logic [23:0] v0_color, v1_color, v2_color, v3_color;
		logic signed [19:0] z1, z2, z3, z1_add_z2, z_reult;
		logic [15:0] color0_R, color0_G, color0_B, color1_R, color1_G, color1_B, color2_R, color2_G, color2_B;
		logic overflow0, overflow1, overflow2, overflow3, overflow4, overflow5, overflow6, overflow7, overflow8, overflow9, overflow10, overflow11, overflow12 ;
		logic [23:0] color_result;
		
		assign w0 = (x - proj_vertex[1][35:26]) * (proj_vertex[2][25:16] - proj_vertex[1][25:16]) - (y - proj_vertex[1][25:16]) * (proj_vertex[2][35:26] - proj_vertex[1][35:26]);
		assign w1 = (x - proj_vertex[2][35:26]) * (proj_vertex[0][25:16] - proj_vertex[2][25:16]) - (y - proj_vertex[2][25:16]) * (proj_vertex[0][35:26] - proj_vertex[2][35:26]);
		assign w2 = (x - proj_vertex[0][35:26]) * (proj_vertex[1][25:16] - proj_vertex[0][25:16]) - (y - proj_vertex[0][25:16]) * (proj_vertex[1][35:26] - proj_vertex[0][35:26]);
 
		
		assign z = (w0 > 5 && w1 > 5 && w2 > 5) ? z_reult : {{1'b1},{19{1'b0}}};
		assign color = ( proj_vertex[0][35:26] > 640 || proj_vertex[1][35:26] > 640 || proj_vertex[2][35:26] > 640 
							|| proj_vertex[0][25:16] > 480 || proj_vertex[1][25:16] > 480 || proj_vertex[2][25:16] > 480 ) ? 0 : ((w0 > 5 && w1 > 5 && w2 > 5) ? color_result : 0);
		assign area = (proj_vertex[0][35:26] - proj_vertex[2][35:26]) * (proj_vertex[1][25:16] - proj_vertex[2][25:16]) - (proj_vertex[0][25:16] - proj_vertex[2][25:16]) * (proj_vertex[1][35:26] - proj_vertex[2][35:26]);
		// z-buffer
		always@(*)begin
			case(set)
				0:begin
					v0_color = point0;
					v1_color = point1;
					v2_color = point2;					
				end
				1:begin
					v0_color = point0;
					v1_color = point3;
					v2_color = point1;
				end
				2:begin
					v0_color = point0;
					v1_color = point2;
					v2_color = point3;
				end
				3:begin
					v0_color = point3;
					v1_color = point2;
					v2_color = point1;
				end
				4:begin
					v0_color = point3;
					v1_color = point2;
					v2_color = point1;
				end
				default:begin
					v0_color = 0;
					v1_color = 0;
					v2_color = 0;
				end
			endcase
		end
		fxp_div #(
			.WIIA(19), .WIFA(0),
			.WIIB(19), .WIFB(0),
			.WOI(2), .WOF(8), .ROUND(1)
		) div0 (.dividend(w0), .divisor(area), .out(w0_area), .overflow(overflow0));
		fxp_div #(
			.WIIA(19), .WIFA(0),
			.WIIB(19), .WIFB(0),
			.WOI(2), .WOF(8), .ROUND(1)
		) div1 (.dividend(w1), .divisor(area), .out(w1_area), .overflow(overflow1));
		fxp_div #(
			.WIIA(19), .WIFA(0),
			.WIIB(19), .WIFB(8),
			.WOI(2), .WOF(8), .ROUND(1)
		) div2 (.dividend(w2), .divisor(area), .out(w2_area), .overflow(overflow2));
		/*fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul0 (.ina(proj_vertex[0][15:0]), .inb(w0_area), .out(z1), .overflow(overflow3));
		fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul1 (.ina(proj_vertex[1][15:0]), .inb(w1_area), .out(z2), .overflow(overflow4));
		fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(0),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul2 (.ina(proj_vertex[2][15:0]), .inb(w2_area), .out(z3), .overflow(overflow5));
		fxp_add #(   
			.WIIA(12), .WIFA(8),
			.WIIB(12), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) add0 (.ina(z1), .inb(z2), .out(z1_add_z2), .overflow(overflow6));
		fxp_add #(   
			.WIIA(12), .WIFA(8),
			.WIIB(12), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) add1 (.ina(z1_add_z2), .inb(z3), .out(z_reult), .overflow(overflow7));
		// color
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C0 (.ina(v0_color[23:16]), .inb(w0_area), .out(color0_R), .overflow(overflow8));
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C1 (.ina(v0_color[15:8]), .inb(w0_area), .out(color0_G), .overflow(overflow9));
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C2 (.ina(v0_color[7:0]), .inb(w0_area), .out(color0_B), .overflow(overflow10));
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C3 (.ina(v1_color[23:16]), .inb(w1_area), .out(color1_R), .overflow(overflow11));
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C4 (.ina(v1_color[15:8]), .inb(w1_area), .out(color1_G), .overflow(overflow12));
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C5 (.ina(v1_color[7:0]), .inb(w1_area), .out(color1_B), .overflow());
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C6 (.ina(v2_color[23:16]), .inb(w2_area), .out(color2_R), .overflow());
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C7 (.ina(v2_color[15:8]), .inb(w2_area), .out(color2_G), .overflow());
		fxp_mul #(
			.WIIA(8), .WIFA(0),
			.WIIB(2), .WIFB(8),
			.WOI(8), .WOF(8), .ROUND(1)
		) mul_C8 (.ina(v2_color[7:0]), .inb(w2_area), .out(color2_B), .overflow());
		fxp_add #(   
			.WIIA(8), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C0 (.ina(color0_R), .inb(color1_R), .out(color0_R_add_color1_R), .overflow());
		fxp_add #(   
			.WIIA(9), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C1 (.ina(color0_R_add_color1_R), .inb(color2_R), .out(color_R_total), .overflow());
		fxp_add #(   
			.WIIA(8), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C2 (.ina(color0_G), .inb(color1_G), .out(color0_G_add_color1_G), .overflow());
		fxp_add #(   
			.WIIA(9), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C3 (.ina(color0_G_add_color1_G), .inb(color2_G), .out(color_G_total), .overflow());
		fxp_add #(   
			.WIIA(8), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C4 (.ina(color0_B), .inb(color1_B), .out(color0_B_add_color1_B), .overflow());
		fxp_add #(   
			.WIIA(9), .WIFA(8),
			.WIIB(8), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) add_C5 (.ina(color0_B_add_color1_B), .inb(color2_B), .out(color_B_total), .overflow());
		
		logic [7:0] color_R_total_new, color_G_total_new, color_B_total_new;
		logic [16:0] color_R_total, color_G_total, color_B_total;
		
		assign color_R_total_new = (color_R_total[16:8] > 'd255)? 8'd255 : color_R_total[15:8];
		assign color_G_total_new = (color_G_total[16:8] > 'd255)? 8'd255 : color_G_total[15:8];
		assign color_B_total_new = (color_B_total[16:8] > 'd255)? 8'd255 : color_B_total[15:8];*/
		logic [15:0] v0z, v1z, v2z;
		assign v0z = proj_vertex[0][15:0];
		assign v1z = proj_vertex[1][15:0];
		assign v2z = proj_vertex[2][15:0];
		fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul0 (.ina(v0z), .inb(w0_area), .out(z1), .overflow(overflow3));
		fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul1 (.ina(v1z), .inb(w1_area), .out(z2), .overflow(overflow4));
		fxp_mul #(
			.WIIA(8), .WIFA(8),
			.WIIB(2), .WIFB(0),
			.WOI(12), .WOF(8), .ROUND(1)
		) mul2 (.ina(v2z), .inb(w2_area), .out(z3), .overflow(overflow5));
		fxp_add #(   
			.WIIA(12), .WIFA(8),
			.WIIB(12), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) add0 (.ina(z1), .inb(z2), .out(z1_add_z2), .overflow(overflow6));
		fxp_add #(   
			.WIIA(12), .WIFA(8),
			.WIIB(12), .WIFB(8),
			.WOI(12), .WOF(8), .ROUND(1)
		) add1 (.ina(z1_add_z2), .inb(z3), .out(z_reult), .overflow(overflow7));
		
	/*	assign z1 = v0z*w0_area;
		assign z1 = v0z*w0_area;
		assign z1 = v0z*w0_area;
		assign z_reult = z1+z2+z3;*/
		 
		
		// color
		logic [27:0] R_total, G_total, B_total;
		logic [16:0] color_R_total, color_G_total, color_B_total;
		logic [ 7:0] color_R_total_new, color_G_total_new, color_B_total_new;
		logic [19:0] area_new;
		always_comb
		begin
			R_total = {v0_color[23:16]} * w0 + {v1_color[23:16]} * w1 + {v2_color[23:16]} * w2;
			G_total = {v0_color[15: 8]} * w0 + {v1_color[15: 8]} * w1 + {v2_color[15: 8]} * w2;
			B_total = {v0_color[ 7: 0]} * w0 + {v1_color[ 7: 0]} * w1 + {v2_color[ 7: 0]} * w2;	
			if(area > 0)
				area_new =  area;
			else
				area_new = -area;
			case(set)  
			    0:begin
			         if(point0==point1 && point1 ==point2)begin
                        color_R_total_new = point0[23:16];
			            color_G_total_new = point0[15:8];
			            color_B_total_new = point0[7:0];					 
					end
                    else begin					
						color_R_total_new = R_total/area_new;
			            color_G_total_new = G_total/area_new;
			            color_B_total_new = B_total/area_new;
					end
				end
				1:begin
			         if(point0==point1 && point1 ==point3)begin
                        color_R_total_new = point0[23:16];
			            color_G_total_new = point0[15:8];
			            color_B_total_new = point0[7:0];					 
					end
                    else begin					
						color_R_total_new = R_total/area_new;
			            color_G_total_new = G_total/area_new;
			            color_B_total_new = B_total/area_new;
					end
				end
				2:begin
			         if(point0==point2 && point3 ==point2)begin
                        color_R_total_new = point0[23:16];
			            color_G_total_new = point0[15:8];
			            color_B_total_new = point0[7:0];					 
					end
                    else begin					
						color_R_total_new = R_total/area_new;
			            color_G_total_new = G_total/area_new;
			            color_B_total_new = B_total/area_new;
					end
				end
				3:begin
			         if(point3==point1 && point3 ==point2)begin
                        color_R_total_new = point0[23:16];
			            color_G_total_new = point0[15:8];
			            color_B_total_new = point0[7:0];					 
					end
                    else begin					
						color_R_total_new = R_total/area_new;
			            color_G_total_new = G_total/area_new;
			            color_B_total_new = B_total/area_new;
					end
				end
				4:begin
			         if(point3==point1 && point3 ==point2)begin
                        color_R_total_new = point0[23:16];
			            color_G_total_new = point0[15:8];
			            color_B_total_new = point0[7:0];					 
					end
                    else begin					
						color_R_total_new = R_total/area_new;
			            color_G_total_new = G_total/area_new;
			            color_B_total_new = B_total/area_new;
					end
				end
				default:begin			        					
						color_R_total_new = 0;
			            color_G_total_new = 0;
			            color_B_total_new = 0;					
				end
			endcase	

			/*color_R_total_new = R_total/area_new;
			color_G_total_new = G_total/area_new;
			color_B_total_new = B_total/area_new;*/
						
		end
		
		/*fxp_div #(
			.WIIA(28), .WIFA(0),
			.WIIB(19), .WIFB(0),
			.WOI(9), .WOF(8), .ROUND(1)
		) div0 (.dividend(R_total), .divisor(area), .out(color_R_total), .overflow(overflow0));
		fxp_div #(
			.WIIA(28), .WIFA(0),
			.WIIB(19), .WIFB(0),
			.WOI(9), .WOF(8), .ROUND(1)
		) div1 (.dividend(G_total), .divisor(area), .out(color_G_total), .overflow(overflow0));
		fxp_div #(
			.WIIA(28), .WIFA(0),
			.WIIB(19), .WIFB(8),
			.WOI(9), .WOF(8), .ROUND(1)
		) div2 (.dividend(B_total), .divisor(area), .out(color_B_total), .overflow(overflow0));*/
		
		
		
		
		//assign color_R_total_new = (color_R_total[16:8] > 'd255)? 8'd255 : color_R_total[15:8];
		//assign color_G_total_new = (color_G_total[16:8] > 'd255)? 8'd255 : color_G_total[15:8];
		//assign color_B_total_new = (color_B_total[16:8] > 'd255)? 8'd255 : color_B_total[15:8];
	/*	logic [7:0] color_R_total_light, color_G_total_light, color_B_total_light;
fxp_mul #(
    .WIIA(8), .WIFA(0),
    .WIIB(2), .WIFB(4),
    .WOI(8), .WOF(0), .ROUND(1)
) mul3 (.ina(color_R_total_new), .inb(out1), .out(color_R_total_light), .overflow());
fxp_mul #(
    .WIIA(8), .WIFA(0),
    .WIIB(2), .WIFB(4),
    .WOI(8), .WOF(0), .ROUND(1)
) mul4 (.ina(color_G_total_new), .inb(out1), .out(color_G_total_light), .overflow());
fxp_mul #(
    .WIIA(8), .WIFA(0),
    .WIIB(2), .WIFB(4),
    .WOI(8), .WOF(0), .ROUND(1)
) mul5 (.ina(color_B_total_new), .inb(out1), .out(color_B_total_light), .overflow());

*/
      logic [7:0] color_R_total_light, color_G_total_light, color_B_total_light;
		logic [13:0] RR,GG,BB;
      assign RR=color_R_total_new * para_out;
		assign GG=color_G_total_new * para_out;
		assign BB=color_B_total_new * para_out;
      assign color_R_total_light = (RR[12:4]> 255)?255:RR[11:4];
      assign color_G_total_light = (GG[12:4]> 255)?255:GG[11:4];
		assign color_B_total_light = (BB[12:4]> 255)?255:BB[11:4];
		/*assign color_R_total_light = RR[11:4];
      assign color_G_total_light = GG[11:4];
		assign color_B_total_light = BB[11:4];*/
		
		assign color_result = {color_R_total_light, color_G_total_light, color_B_total_light};

		
		
		//assign color_result = {color_R_total_new, color_G_total_new, color_B_total_new};


endmodule
