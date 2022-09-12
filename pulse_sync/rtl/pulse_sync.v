module pulse_sync(
	clka	,
	rstna	,
	clkb	,
	rstnb	,
	a_pul	,
	b_pul
);

input		clka;
input		rstna;
input		clkb;
input		rstnb;
input		a_pul;
output		b_pul;

wire		clka;
wire		rstna;
wire		clkb;
wire		rstnb;
wire		a_pul;
reg			a_lat;
reg			a2b_d1;
reg			a2b_d2;
reg			a2b_d3;
reg			b2a_d1;
reg			b2a_d2;
reg			b2a_d3;
reg			b_pul;


always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		a_lat <= 1'b0;
	end
	else if (a2b_d2)begin /*IMPORTANT*/
		a_lat <= 1'b0;
	end
	else if (a_pul)begin
		a_lat <= 1'b1;
	end
end

always @ (negedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		a2b_d1 <= 1'b0;
	end
	else begin
		a2b_d1 <= a_lat;
	end
end

always @ (negedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		a2b_d2 <= 1'b0;
		a2b_d3 <= 1'b0;
	end
	else begin
		a2b_d2 <= a2b_d1;
		a2b_d3 <= a2b_d2;
	end
end
assign b_pul = a2b_d2 & ~a2b_d3;
