timescale lns/lps
module tb;

reg			clka;
reg			rstna;
reg			clkb;
reg			rstnb;
reg			a_pul;
wire		b_pul;

initial
begin
	#0;
	clka = 1'b0;
	rstna = 1'b0;
	a_pul = 1'b0;
	#1001;
	rstna = 1'b1;
	#10000;
	a_pul = 1'b1;
	#25;
	a_pul = 1'b0;
	#10000;
	a_pul = 1'b1;
	#25;
	a_pul = 1'b0;
end

always
begin
	#12.5 clka = ~clka;
end

initial
begin
	#0;
	clkb = 1'b0;
	rstnb = 1'b0;
	#301;
	rstnb = 1'b1;
end
initial
begin
	#1000000;
	$finish;
end

always
begin
	#15 clkb = ~clkb;
end


pulse_sync pulse_sync(
	.clka(clka),
	.rstna(rstna),
	.clkb(clkb),
	.rstnb(rstnb),
	.a_pul(a_pul),
	.b_pul(b_pul)
);

initial
begin
	$fsdbDumpfile("./test.fsdb");
	$fsdbDumpvars(0, tb, "+struct", "+mda");
	$fsdbDumpMDA(0);
	$fsdbDumpon;
end

endmodule
