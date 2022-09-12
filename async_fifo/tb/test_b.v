module test_b(
	clkb	,
	rstnb	,
	rreqb	,
	rdatb	,
	emptyb

);

input		clkb;
input		rstnb;

output		rreqb;
output [7:0]rdatb;
input 		emptyb;
//Boundary
wire		clkb;
wire		rstnb;
reg			rreqb;
reg	   [7:0]rdatb;
wire		emptyb;


//Body
always @ (posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		rreqb <= 1'b0;
	end
	else if (~emptyb)begin
		rreqb <= 1'b1;
	end
	else begin
		rreqb <= 1'b0;
	end
end


endmodule
