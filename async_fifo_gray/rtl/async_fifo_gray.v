module async_fifo(
	clka	,
	rstna	,
	clkb	,
	rstnb	,
	wreqa	,
	fulla	,
	rreqb	,
	rdatb	,
	emptyb
);
parameter ASIZE = 4;
parameter DSIZE = 8;
input				clka;
input				rstna;
input				wreqa;
input [DSIZE-1:0] 	wdata;
output wire			fulla;
reg   [ASIZE-1:0]	wr_ptr;
reg   [ASIZE-1:0]	wr_ptr_safe;
reg   [ASIZE-1:0]	wr_ptr_nxt;
reg   [ASIZE-1:0]	wr_ptr_g;
reg   [ASIZE-1:0]	wr_sync_d1;
reg   [ASIZE-1:0]	wr_sync_d2;
reg   [ASIZE-1:0]	wr_sync_d3;
reg   [ASIZE-1:0]	wr_ptr_sync;

input					clkb;
input					rstnb;
input					rreqb;
output reg[DSIZE-1:0]	rdatb;
output wire				emptyb;
reg   [ASIZE-1:0]		rd_ptr_g;
reg   [ASIZE-1:0]		rd_sync_d1;
reg   [ASIZE-1:0]		rd_sync_d2;
reg   [ASIZE-1:0]		rd_sync_d3;
reg   [ASIZE-1:0]		rd_ptr_sync;
reg   [DSIZE-1:0] 		mem[DSIZE-1:0];

/*Dual Port RAM**/
always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		wr_ptr <= 4'h0;
		mem[wr_ptr[2:0]] <= 8'h0;
	end
	else if (wreqa)begin
		mem[wr_ptr[2:0]] <= wdata;
		wr_ptr <= wr_ptr + 4'h1;
	end
end
assign wr_ptr_nxt = wr_ptr + 1'b1;

always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		wr_ptr_safe <= 4'h0;
	end
	else begin
		wr_ptr_safe <= wr_ptr;
	end
end

always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		rd_sync_d1 <= 4'h0;
		rd_sync_d2 <= 4'h0;
	end
	else begin
		rd_sync_d1 <= rd_ptr_g;
		rd_sync_d2 <= rd_sync_d1;
	end
end


always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		rd_ptr <= 4'h0;
	end
	else if (rreqb)begin
		rdatb <= mem[rd_ptr[2:0]];
		rd_ptr <= rd_ptr + 4'h1;
	end
end

always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		rd_ptr_safe <= 4'h0;
	end
	else begin
		rd_ptr_safe <= rd_ptr;
	end
end

always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		wr_sync_d1 <= 4'h0;
		wr_sync_d2 <= 4'h0;
	end
	else begin
		wr_sync_d1 <= wr_ptr_g;
		wr_sync_d2 <= wr_sync_d1;
	end
end

/*binary to graycode*/
assign wr_ptr_g = wr_ptr_safe ^ (wr_ptr_safe >> 1);
assign rd_ptr_g = rd_ptr_safe ^ (rd_ptr_safe >> 1);
/*graycode to binary*/
assign wr_ptr_sync = wr_sync_d2 ^ (wr_sync_d2 >> 1) ^ (wr_sync_d2 >> 2) ^ (wr_sync_d2 >> 3);
assign rd_ptr_sync = rd_sync_d2 ^ (rd_sync_d2 >> 1) ^ (rd_sync_d2 >> 2) ^ (rd_sync_d2 >> 3);

/*Full & Empty Logic Design**/
assign fulla = ((wr_ptr_nxt[ASIZE-2:0] == rd_ptr_sync[ASIZE-2:0]) & (wr_ptr_nxt[ASIZE-1] != rd_ptr_sync[ASIZE-1])) |
				(wr_ptr[ASIZE-2:0] == rd_ptr_sync[ASIZE-2:0]) & (wr_ptr[ASIZE-1] != rd_ptr_sync[ASIZE-1]));
assign emptyb = ((rd_ptr == wr_ptr_sync) | ((rd_ptr + 4'b1) == wr_ptr_sync));


endmodule;
