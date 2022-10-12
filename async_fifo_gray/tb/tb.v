timescale lns/lps
module tb;

reg			clka;
reg			rstna;
reg			clkb;
reg			rstnb;
wire		wreqa;
wire [7:0]  wdata;
wire		fulla;
wire		rreqb;
wire [7:0]  rdatb;
wire		emptyb;

initial
begin
	#0;
	clka = 1'b0;
	rstna = 1'b0;
	#101;
	rstna = 1'b1;
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
	#91;
	rstnb = 1'b1;
end

always
begin
	#15 clkb = ~clkb;
end

test_a test_a(
	.clka(clka),
	.rstna(rstna),
	.wreqa(wreqa),
	.wdata(wdata),
	.fulla(fulla)
);

test_b test_b(
	.clkb(clkb),
	.rstnb(rstnb),
	.rreqb(rreqb),
	.rdata(rdata),
	.emptyb(emptyb)
);

async_fifo async_fifo(
	.clka(clka),
	.rstna(rstna),
	.clkb(clkb),
	.rstnb(rstnb),
	
	.wreqa(wreqa),
	.wdata(wdata),
	.fulla(fulla),
	
	.rreqb(rreqb),
	.rdata(rdata),
	.emptyb(emptyb)
);

initial
begin
	#100000000;
	$finish;
end

initial
begin
	$fsdbDumpfile("./test.fsdb");
	$fsdbDumpvars(0, tb, "+struct", "+mda");
	$fsdbDumpMDA(0);
	$fsdbDumpon;
end

endmodule
