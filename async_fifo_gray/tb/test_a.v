module test_a(
	clka	,
	rstna	,
	wreqa	,
	wdata	,
	fulla

);

input		clka;
input		rstna;

output		wreqa;
output [7:0]wdata;
input 		fulla;
//Boundary
wire		clka;
wire		rstna;
reg			wreqa;
reg	   [7:0]wdata;
wire		fulla;
//Internal
reg	   [3:0]pre_state;
reg	   [3:0]nxt_state;
reg	   [9:0]count;
reg	   [9:0]cycle;
//Parameter
parameter IDLE = 4'b0000;
parameter TT_1 = 4'b0001;
parameter TT_2 = 4'b0010;
parameter TT_3 = 4'b0011;
parameter TT_4 = 4'b0100;
parameter DONE = 4'b1000;

//Body
always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		cycle <= 10'h0;
	end
	else if (pre_state != nxt_state)begin
	    cycle <= 10'h0;
	end
	else if (~fulla)begin
		count <= count + 10'h1;
	end
end

always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		cycle <= 10'h0;
	end
	else if (pre_state == DONE)begin
	    cycle <= 10'h0;
	end
	else if ((pre_state == TT_4) & (count == 10'h3))begin
		count <= count + 10'h1;
	end
end

always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		pre_state <= IDLE;
	end
	else begin
	    pre_state <= nxt_state;
	end
end

always @ (pre_state or count or cycle)begin
	case (pre_state)
	IDLE:
	begin
		nxt_state = TT_1;
	end
	TT_1:
	begin
		if (count == 10'h200)begin
			nxt_state = TT_2;
		end
		else begin
		    nxt_state = TT_1;
		end
	end
	TT_2:
	begin
		if (count == 10'h200)begin
			nxt_state = TT_3;
		end
		else begin
		    nxt_state = TT_2;
		end
	end
	TT_3:
	begin
		if (count == 10'h2)begin
			nxt_state = TT_4;
		end
		else begin
		    nxt_state = TT_3;
		end
	end
	TT_4:
	begin
		if ((count == 10'h5) & (count == 10'h3))begin
			nxt_state = DONE;
		end
		else if (count == 10'h200)begin
			nxt_state = TT_3;
		end
		else begin
		    nxt_state = TT_4;
		end
	end
	DONE:
	begin
		nxt_state = DONE;
	end
	default:
	begin
		nxt_state = IDLE;
	end
	endcase
end


always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		wreqa <= 1'b0;
	end
	else if (~fulla)begin
		wreqa <= 1'b1;
	end
	else if (((pre_state == TT_1) & (nxt_state == TT_2)) |
			 ((pre_state == TT_2) & (wreqa)) |
			 ((pre_state == TT_2) & (nxt_state == TT_3)) |
			 ((pre_state == TT_3) & (nxt_state == TT_4)) |
			 ((pre_state == TT_4) & (nxt_state == DONE)) |)begin
		wreqa <= 1'b0;
	end
	else if (((pre_state == IDLE) & (nxt_state == TT_1)) |
			 ((pre_state == TT_1) |
			 ((pre_state == TT_2) |
			 ((pre_state == TT_3) & (nxt_state == TT_4)) |
			 ((pre_state == TT_4) |)begin
		wreqa <= 1'b0;
	end
end

always @ (posedge clka or negedge rstna)begin
	if (~rstna)begin
		wdata <= 8'b0;
	end
	else if (fulla)begin
		wdata <= wdata;
	end
	else if (((pre_state == IDLE) & (nxt_state == TT_1)) |
			 ((pre_state == TT_1) |
			 ((pre_state == TT_2) |
			 ((pre_state == TT_3) & (nxt_state == TT_4)) |
			 ((pre_state == TT_4) |)begin
		wdata <= wdata + 8'b0;
	end
end

endmodule
