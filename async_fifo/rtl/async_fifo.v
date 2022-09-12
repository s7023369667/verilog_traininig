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

input		clka;
input		rstna;
input		wreqa;
input [7:0] wdata;
output		fulla;
wire		fulla;
reg			a2b_d1;
reg			a2b_d2;
reg			a2b_d3;
reg			a_lat;
reg			tmp_pul;
reg   [3:0] a_bus;
reg			a_en;
reg	  [3:0] a_get_rdptr;
reg   [3:0] wr_ptr;
reg   [3:0] wr_ptr_nxt;

input		clkb;
input		rstnb;
input		rreqb;
output [7:0]rdatb;
reg    [7:0]rdatb
output		emptyb;
wire		emptyb;
reg			b2a_d1;
reg			b2a_d2;
reg			b2a_d3;
wire		b_pul;
reg   [3:0] b_bus;
reg			a_en;
reg   [3:0] rd_ptr
reg	  [3:0] b_get_wrptr;
reg   [7:0] mem[7:0];

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

always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		rd_ptr <= 4'h0;
	end
	else if (rreqb)begin
		rdatb <= mem[rd_ptr[2:0]];
		rd_ptr <= rd_ptr + 4'h1;
	end
end

/*Generate a_bus & b_bus**/
always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		a_bus <= 4'h0;
	end
	else if (tmp_pul)begin
		a_bus <= wr_ptr;
	end
end

always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		b_bus <= 4'h0;
	end
	else if (b_pul)begin
		b_bus <= rd_ptr;
	end
end

always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		a_get_rdptr <= 4'h0;
	end
	else if (tmp_pul)begin
		a_get_rdptr <= b_bus;
	end
end

always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		b_get_wrptr <= 4'h0;
	end
	else if (b_pul)begin
		b_get_wrptr <= a_bus;
	end
end
/*Full & Empty Logic Design**/
assign fulla = ((wr_ptr_nxt[2:0] == a_get_rdptr[2:0]) & (wr_ptr_nxt[3] != a_get_rdptr[3])) |
				(wr_ptr[2:0] == a_get_rdptr[2:0]) & (wr_ptr[3] != a_get_rdptr[3]));
assign emptyb = ((rd_ptr == b_get_wrptr) | ((rd_ptr + 1'b1) == b_get_wrptr));

/*a-domain sync to b-domain**/
always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		a_lat <= 1'b0;
	end
	else if (tmp_pul)begin
		a_lat <= 1'b0;
	end
	else if (a_en)begin
		a_lat <= 1'b1;
	end
end
always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		a_en <= 1'b1;
	end
	else if (tmp_pul)begin
		a_en <= 1'b1;
	end
	else begin
		a_en <= 1'b0;
	end
end
always @(posedge clkb or negedge rstnb)begin
	if (~rstnb)begin
		a2b_d1 <= 1'b0;
		a2b_d2 <= 1'b0;
		a2b_d3 <= 1'b0;
	end
	else begin
		a2b_d1 <= a_lat;
		a2b_d2 <= a2b_d1;
		a2b_d3 <= a2b_d2;
	end
end
assign b_pul = a2b_d2 & (~a2b_d3);
/*b-domain sync to a-domain**/
always @(posedge clka or negedge rstna)begin
	if (~rstna)begin
		b2a_d1 <= 1'b0;
		b2a_d2 <= 1'b0;
		b2a_d3 <= 1'b0;
	end
	else begin
		b2a_d1 <= a2b_d2;
		b2a_d2 <= b2a_d1;
		b2a_d3 <= b2a_d2;
	end
end
assign tmp_pul = b2a_d2 & (~b2a_d3);

endmodule;
