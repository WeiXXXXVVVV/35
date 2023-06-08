module light#(
   
    parameter WII = 8,
    parameter WIF = 8,
    
    parameter WOI = 8,
    parameter WOF = 8
) (inax,inay,inaz,inbx,inby,inbz,incx,incy,incz,out1);

//input Clk;
//input Reset;
input signed [WII+WIF-1:0] inax,inay,inaz,inbx,inby,inbz,incx,incy,incz;
//input [143:0] in1;
output logic [5:0] out1;
//logic [5:0] out2;
logic [15:0] v1,v2,v3; //法向量
logic [15:0] l1,l2,l3; //光向量 
logic [15:0] vt1,vt2,vt3,vt4,vt5,vt6,vt7,vt8,vt9,vt10,vt11,vt12,vt13,vt14,vt15,vt16,vt17,vt18,vt19,vt20,vt21,vt22,vt23,vt24,vt25; 
logic [15:0] ve1,ve2,ve3,vr1,vr2,vr3;//三角形向量
logic [15:0] ve11,ve12,ve13,vr11,vr12,vr13;
logic [15:0] n1,n2,n3,n4,n5,n6;
logic [15:0] cos,out2;
logic o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20,o21,o22,o23,o24,o25,o26,o27,o28,o29,o30,o31,o32,o33,o34,o35;//overflow
assign l1 =16'b0000000100000000;
assign l2 =16'b0000000100000000;
assign l3 =16'b0000000100000000;

/*assign ve1 =  inbx-inax;//向量1x
assign ve2 =  inby-inay;//向量1y
assign ve3 =  inbz-inaz;//向量1z
assign vr1 =  incx-inax;//向量2x
assign vr2 =  incy-inay;//向量2y
assign vr3 =  incz-inaz;//向量2z
assign v1 = ve2*vr3 - ve3*vr2; //法向量x
assign v2 = ve3*vr1 - ve1*vr3;//法向量y
assign v3 = ve1*vr2 - ve2*vr1;//法向量z
*/
always_comb begin

    if($signed(n1)<=0  )begin
	    out1=6'b001000;
		end
    else begin
	   out1 = cos + 6'b001000;
	   end
    
end
/*
always_comb begin
    n1= v1*l1 +v2*l2 +v3*l3;//分子相乘
	n2 = v1*v1 +v2*v2 +v3*v3;//輸入norm
	n3 = l1*l1 +l2*l2+l3*l3;//光norm
	n6= n4*n5;
	cos= n1/n6
	//out1= cos + 16'b0000000010000000;
end
*/
//vector 
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn0(
    .ina(inbx),
    .inb(inax),
    .sub(1'b1),
    .out(ve1),
    .overflow(o2)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn1 (
    .ina(inby),
    .inb(inay),
    .sub(1'b1),
    .out(ve2),
    .overflow(o3)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn2 (
    .ina(inbz),
    .inb(inaz),
    .sub(1'b1),
    .out(ve3),
    .overflow(o4)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn3 (
    .ina(incx),
    .inb(inax),
    .sub(1'b1),
    .out(vr1),
    .overflow(o5)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn4 (
    .ina(incy),
    .inb(inay),
    .sub(1'b1),
    .out(vr2),
    .overflow(o6)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn5 (
    .ina(incz),
    .inb(inaz),
    .sub(1'b1),
    .out(vr3),
    .overflow(o7)
);



//法向量
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul30 (.ina(ve2), .inb(vr3), .out(vt1), .overflow(o8));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul31 (.ina(ve3), .inb(vr2), .out(vt2), .overflow(o9));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul32 (.ina(ve3), .inb(vr1), .out(vt3), .overflow(o10));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul33 (.ina(ve1), .inb(vr3), .out(vt4), .overflow(o11));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul34 (.ina(ve1), .inb(vr2), .out(vt5), .overflow(o12));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul35 (.ina(ve2), .inb(vr1), .out(vt6), .overflow(o13));

fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn6(
    .ina(vt1),
    .inb(vt2),
    .sub(1'b1),
    .out(v1),
    .overflow(o14)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn7(
    .ina(vt3),
    .inb(vt4),
    .sub(1'b1),
    .out(ve1),
    .overflow(o15)
);
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn8(
    .ina(vt5),
    .inb(vt6),
    .sub(1'b1),
    .out(ve1),
    .overflow(o16)
);
//內積

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul36 (.ina(v1), .inb(l1), .out(vt7), .overflow(o14));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul37 (.ina(v2), .inb(l2), .out(vt8), .overflow(o15));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul38 (.ina(v3), .inb(l3), .out(vt9), .overflow(o16));

fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add10 (.ina(vt7), .inb(vt8), .out(vt10), .overflow(o17));
fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add11 (.ina(vt10), .inb(vt9), .out(n1), .overflow(o18));


fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul39 (.ina(v1), .inb(v1), .out(vt12), .overflow(o19));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul40 (.ina(v2), .inb(v2), .out(vt13), .overflow(o20));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul41 (.ina(v3), .inb(v3), .out(vt14), .overflow(o21));

fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add12 (.ina(vt12), .inb(vt13), .out(vt15), .overflow(o22));
fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add13 (.ina(vt15), .inb(vt14), .out(n2), .overflow(o23));





fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul42 (.ina(l1), .inb(l1), .out(vt17), .overflow(o24));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul43 (.ina(l2), .inb(l2), .out(vt18), .overflow(o25));
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul44 (.ina(l3), .inb(l3), .out(vt19), .overflow(o26));

fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add14 (.ina(vt17), .inb(vt18), .out(vt20), .overflow(o27));
fxp_add #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) add15 (.ina(vt20), .inb(vt19), .out(n3), .overflow(o28));




//sqrt
fxp_sqrt #(.WII(WII), .WIF(WIF),.WOI(WOI), .WOF(WOF), .ROUND(1))
    sqrt1(
	  .in(n2),
	  .out(n4),
	  .overflow(o1),
);
fxp_sqrt #(.WII(WII), .WIF(WIF),.WOI(WOI), .WOF(WOF), .ROUND(1))
    sqrt2(
	  .in(n3),
	  .out(n5),
	  .overflow(o2),
);

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) mul45 (.ina(n4), .inb(n5), .out(n6), .overflow(o29));


fxp_div #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(8), .WIFB(8),
    .WOI(2), .WOF(4), .ROUND(1)
) div20 (.dividend(n1), .divisor(n6), .out(cos), .overflow(o30));
	  
endmodule	  



/*
light #(
                    .WII(WII), .WIF(WIF),
                    .WOI(WOI), .WOF(WOF)
) get_light (
            .inax(vertex_a[0]),
			.inay(vertex_a[1]),
			.inaz(vertex_a[2]),
			.inbx(vertex_b[0]),
			.inby(vertex_b[1]),
			.inbz(vertex_b[2]),
			.incx(vertex_c[0]),
			.incy(vertex_c[1]),
			.incz(vertex_c[2]),
			.out1(out1),
);

*/
