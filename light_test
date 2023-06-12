module light#(
   
    parameter WII = 8,
    parameter WIF = 8,
    
    parameter WOI = 8,
    parameter WOF = 8
) (inax,inay,inaz,inbx,inby,inbz,incx,incy,incz,para_outr);
//input clk,rst;
input signed [WII+WIF-1:0] inax,inay,inaz,inbx,inby,inbz,incx,incy,incz;
//input [143:0] in1;
output wire [5:0] para_outr;

wire [31:0] v1,v2,v3; //normal vector
wire [15:0] l1,l2,l3; //light 
wire signed [15:0] va1,va2,va3,vb1,vb2,vb3;//vectorab
//wire [15:0] 
wire [31:0] vt1,vt2,vt3,vt4,vt5,vt6; 
wire [63:0] m1,m2,m3,m4,m5,m6,m7,m8,m9;
wire [63:0] norm1,norm2,norm3;
wire [63:0] mu1;
wire [31:0] n1,n2,n3;
wire [31:0] sq1,sq2;

//wire [7:0] va11,va21,va31,vb11,vb21,vb31;
//wire [15:0] v11,v21,v31,cost;

wire o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15,o16,o17,o18,o19,o20,o21,o22,o23,o24,o25,o26,o27,o28,o29,o30,o31,o32,o33,o34,o35;//overflow
wire [31:0] cos;
wire [5:0] cos1,out2,low;
assign cos1 = cos[17:12];
assign l1 =16'b0000000100000000;
assign l2 =16'b0000000100000000;
assign l3 =16'b0000000100000000;
assign n1 = norm1[63:32];
assign n2 = norm2[63:32];
assign n3 = norm3[63:32];
assign out2 = cos1+6'b001000;
assign low = 6'b001000;
assign sq2 = 16'b00000000000000011011101101101000;
/*always_comb begin

    if($signed(norm1)<=0  )begin
	   out1=low;
	  end
    else begin
	   out1 =out2;
	   end
    
end*/
assign para_outr=($signed(norm1)<=0)?low:out2;
//assign para_outr =6'b001000;

//vectorab
fxp_addsub #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WOI), .WIFB(WOF),
    .WOI(WOI), .WOF(WOF), .ROUND(1)
) admn0(
    .ina(inbx),
    .inb(inax),
    .sub(1'b1),
    .out(va1),
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
    .out(va2),
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
    .out(va3),
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
    .out(vb1),
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
    .out(vb2),
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
    .out(vb3),
    .overflow(o7)
);

//normal vector
fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul30 (.ina(va2), .inb(vb3), .out(vt1), .overflow(o8));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul31 (.ina(va3), .inb(vb1), .out(vt2), .overflow(o9));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul32 (.ina(va1), .inb(vb2), .out(vt3), .overflow(o10));


fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul33 (.ina(va3), .inb(vb2), .out(vt4), .overflow(o11));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul34 (.ina(va1), .inb(vb3), .out(vt5), .overflow(o12));

fxp_mul #(
    .WIIA(WII), .WIFA(WIF),
    .WIIB(WII), .WIFB(WIF),
    .WOI(16), .WOF(16), .ROUND(1)
) mul35 (.ina(va2), .inb(vb1), .out(vt6), .overflow(o13));

fxp_addsub #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(16), .WOF(16), .ROUND(1)
) admn6(
    .ina(vt1),
    .inb(vt4),
    .sub(1'b1),
    .out(v1),
    .overflow(o14)
);
fxp_addsub #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(16), .WOF(16), .ROUND(1)
) admn7(
    .ina(vt2),
    .inb(vt5),
    .sub(1'b1),
    .out(v2),
    .overflow(o15)
);
fxp_addsub #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(16), .WOF(16), .ROUND(1)
) admn8(
    .ina(vt3),
    .inb(vt6),
    .sub(1'b1),
    .out(v3),
    .overflow(o16)
);


//Inner product
fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul36 (.ina(v1), .inb(l1), .out(m1), .overflow(o14));
fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul37 (.ina(v2), .inb(l2), .out(m2), .overflow(o15));
fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul38 (.ina(v3), .inb(l3), .out(m3), .overflow(o16));

assign norm1=m1+m2+m3;



fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(32), .WOF(32), .ROUND(1)
) mul66 (.ina(v1), .inb(v1), .out(m4), .overflow(o17));
fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(32), .WOF(32), .ROUND(1)
) mul77 (.ina(v2), .inb(v2), .out(m5), .overflow(o18));
fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(32), .WOF(32), .ROUND(1)
) mul88 (.ina(v3), .inb(v3), .out(m6), .overflow(o19));

assign norm2=m4+m5+m6;


/*
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul01 (.ina(l1), .inb(l1), .out(m7), .overflow(o20));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul02 (.ina(l2), .inb(l2), .out(m8), .overflow(o21));
fxp_mul #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(32), .WOF(32), .ROUND(1)
) mul03 (.ina(l3), .inb(l3), .out(m9), .overflow(o22));

assign norm3=m7+m8+m9;*/


//sqrt
fxp_sqrt #(.WII(32), .WIF(32),.WOI(16), .WOF(16), .ROUND(1))
    sqrt1(
	  .in(norm2),
	  .out(sq1),
	  .overflow(o1)
);
/*fxp_sqrt #(.WII(32), .WIF(32),.WOI(16), .WOF(16), .ROUND(1))
    sqrt2(
	  .in(norm3),
	  .out(sq2),
	  .overflow(o2)
);*/

fxp_mul #(
    .WIIA(16), .WIFA(16),
    .WIIB(16), .WIFB(16),
    .WOI(32), .WOF(32), .ROUND(1)
) mul45 (.ina(sq1), .inb(sq2), .out(mu1), .overflow(o29));


fxp_div #(
    .WIIA(32), .WIFA(32),
    .WIIB(32), .WIFB(32),
    .WOI(16), .WOF(16), .ROUND(1)
) div20 (.dividend(norm1), .divisor(mu1), .out(cos), .overflow(o30));
/*
fxp_div #(
    .WIIA(8), .WIFA(8),
    .WIIB(8), .WIFB(8),
    .WOI(8), .WOF(8), .ROUND(1)
) div77 (.dividend(norm1), .divisor(mu1), .out(cost), .overflow(o34));

*/
endmodule
