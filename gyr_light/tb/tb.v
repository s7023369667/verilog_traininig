timescale lns/lps
module tb;

reg			clka;
reg			rstn;

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
	#10 clk = ~clk;
end


gry_light gry_light(
	.clk(clk),
	.rstn(rstn),
	.green(),
	.yellow(),
	.red()
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
