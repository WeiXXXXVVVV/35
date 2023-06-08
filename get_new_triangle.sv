module get_new_triangle#(
					parameter WIIA = 8,
                    parameter WIFA =8, 


    parameter WOI = 8,
    parameter WOF = 8
)					
(
               input [15:0][15:0]model_matrix,
				   input [3:0][WIIA+WIFA-1:0] vertex_a, vertex_b, vertex_c,
				   //output logic [5:0] out1
				   //output logic [2:0][15:0]  vertex_a_1, vertex_b_1, vertex_c_1
				   output logic signed [15:0] inax,inay,inaz,inbx,inby,inbz,incx,incy,incz
				   );
				  
//logic [3:0][15:0]	vertex_a_1, vertex_b_1, vertex_c_1;			  
			  
				  
				  
				  
				  
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp80(.a0(model_matrix[0]), .a1(model_matrix[1]), .a2(model_matrix[2]), .a3(model_matrix[3]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(inax));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp81(.a0(model_matrix[4]), .a1(model_matrix[5]), .a2(model_matrix[6]), .a3(model_matrix[7]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(inay));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp82(.a0(model_matrix[8]), .a1(model_matrix[9]), .a2(model_matrix[10]), .a3(model_matrix[11]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(inaz));
//dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp83(.a0(model_matrix[12]), .a1(model_matrix[13]), .a2(model_matrix[14]), .a3(model_matrix[15]), .b0(vertex_a[0]), .b1(vertex_a[1]), .b2(vertex_a[2]), .b3(vertex_a[3]), .res(vertex_a_1[3]));				  

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp90(.a0(model_matrix[0]), .a1(model_matrix[1]), .a2(model_matrix[2]), .a3(model_matrix[3]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(inbx));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp91(.a0(model_matrix[4]), .a1(model_matrix[5]), .a2(model_matrix[6]), .a3(model_matrix[7]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(inby));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp92(.a0(model_matrix[8]), .a1(model_matrix[9]), .a2(model_matrix[10]), .a3(model_matrix[11]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(inbz));
//dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp93(.a0(model_matrix[12]), .a1(model_matrix[13]), .a2(model_matrix[14]), .a3(model_matrix[15]), .b0(vertex_b[0]), .b1(vertex_b[1]), .b2(vertex_b[2]), .b3(vertex_b[3]), .res(vertex_b_1[3]));

dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp70(.a0(model_matrix[0]), .a1(model_matrix[1]), .a2(model_matrix[2]), .a3(model_matrix[3]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(incx));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp71(.a0(model_matrix[4]), .a1(model_matrix[5]), .a2(model_matrix[6]), .a3(model_matrix[7]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(incy));
dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp72(.a0(model_matrix[8]), .a1(model_matrix[9]), .a2(model_matrix[10]), .a3(model_matrix[11]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(incz));
//dot_product #(.WII(WIIA), .WIF(WIFA), .WOI(WIIA), .WOF(WIIA)) dp73(.a0(model_matrix[12]), .a1(model_matrix[13]), .a2(model_matrix[14]), .a3(model_matrix[15]), .b0(vertex_c[0]), .b1(vertex_c[1]), .b2(vertex_c[2]), .b3(vertex_c[3]), .res(vertex_c_1[3]));				  
				  
/*light #(
                    .WII(8), .WIF(8),
                    .WOI(8), .WOF(8)
) get_light (
         .inax(vertex_a_1[0]),
			.inay(vertex_a_1[1]),
			.inaz(vertex_a_1[2]),
			.inbx(vertex_b_1[0]),
			.inby(vertex_b_1[1]),
			.inbz(vertex_b_1[2]),
			.incx(vertex_c_1[0]),
			.incy(vertex_c_1[1]),
			.incz(vertex_c_1[2]),
			.out1(out1)
);		*/		  
				  				 				  				  				  				  				  
				  
				  
						  
				  
endmodule				  