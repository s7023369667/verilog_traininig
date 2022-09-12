module gry_4way_fsm(
	clk	,
	rstn 
);

input 		clk;
input		rstn;
wire		clk;
wire		rstn;
reg			a0_green;
reg			a0_yellow;
reg			a0_red;
reg			a1_green;
reg			a1_yellow;
reg			a1_red;
reg			b0_green;
reg			b0_yellow;
reg			b0_red;
reg			b1_green;
reg			b1_yellow;
reg			b1_red;
reg			dir; 
parameter	IDLE = 2'b00;	
parameter	GREEN = 2'b01;	  
parameter	YELLOW = 2'b10;	  
parameter	RED = 2'b11;	  
reg [3:0]   counter;   
reg [1:0]   now_state;
reg [1:0]   next_state;


always @(posedge clk or negedge rstn)begin
	if (~rstn)begin
		a0_green  <= 1'b1;
		a0_yellow <= 1'b0;
		a0_red    <= 1'b0;
		a1_green  <= 1'b1;
		a1_yellow <= 1'b0;
		a1_red    <= 1'b0;
		b0_green  <= 1'b0;
		b0_yellow <= 1'b0;
		b0_red    <= 1'b1;
		b1_green  <= 1'b0; 
		b1_yellow <= 1'b0;
		b1_red    <= 1'b1;
		dir       <= 1'b1;
		counter   <= 4'h0;
		now_state <= GREEN;
	end
	else begin
		counter   <= counter + 4'h1;
		now_state <= next_state;
	end
end
	
	
always @ (*)begin
	case (now_state)
		GREEN:
		begin
			if ((dir == 1'b1) & (counter == 4'h3))begin
				a0_green  <= 1'b0;
				a0_yellow <= 1'b1;
				a0_red    <= 1'b0;
				a1_green  <= 1'b0;
				a1_yellow <= 1'b1;
				a1_red    <= 1'b0;
				dir 	  <= 1'b1;
				next_state<= YELLOW;
			end
			else if ((dir == 1'b0) & (counter == 4'h3))begin
				b0_green  <= 1'b0;
				b0_yellow <= 1'b1;
				b0_red    <= 1'b0;
				b1_green  <= 1'b0; 
				b1_yellow <= 1'b1;
				b1_red    <= 1'b0;
				dir 	  <= 1'b0;
				next_state<= YELLOW;
			end
		end
		YELLOW:
		begin
			if ((dir == 1'b1) & (counter == 4'h5))begin
				a0_green  <= 1'b0;
				a0_yellow <= 1'b0;
				a0_red    <= 1'b1;
				a1_green  <= 1'b0;
				a1_yellow <= 1'b0;
				a1_red    <= 1'b1;
				dir 	  <= 1'b1;
				next_state<= RED;
			end
			else if ((dir == 1'b0) & (counter == 4'h5))begin
				b0_green  <= 1'b0;
				b0_yellow <= 1'b0;
				b0_red    <= 1'b1;
				b1_green  <= 1'b0; 
				b1_yellow <= 1'b0;
				b1_red    <= 1'b1;
				dir 	  <= 1'b0;
				next_state<= RED;
			end
		end
		RED:
		begin
			if ((dir == 1'b1) & (counter == 4'hd))begin
				a0_green  <= 1'b1;
				a0_yellow <= 1'b0;
				a0_red    <= 1'b0;
				a1_green  <= 1'b1;
				a1_yellow <= 1'b0;
				a1_red    <= 1'b0;
				dir 	  <= 1'b0; /*IMPORTANT*/
				next_state<= GREEN;
			end
			else if ((dir == 1'b0) & (counter == 4'hd))begin
				b0_green  <= 1'b1;
				b0_yellow <= 1'b0;
				b0_red    <= 1'b0;
				b1_green  <= 1'b1; 
				b1_yellow <= 1'b0;
				b1_red    <= 1'b0;
				dir       <= 1'b1; /*IMPORTANT*/
				next_state<= GREEN;
			end
		end
		default:	
		begin
				next_state<= GREEN;
		end
	endcase
	
end

endmodule
