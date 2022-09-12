module gry_light(
	clk	,
	rstn	,
	green	,
	yellow	,
	red	
);

input 		clk;
input		rstn;
output		green;
output		yellow;
output		red;

wire		clk;
wire		rstn;
reg			green;
reg			yellow;
reg			red;

always @(posedge clk)begin
	if (~rstn)begin
		green <= 1'b1;
	end
	else if (red)begin
		green <= 1'b1;
	end
	else if (yellow)begin
		green <= 1'b0;
	end
	else begin
		green <= green;
	end
end

always @(posedge clk)begin
	if (~rstn)begin
		yellow <= 1'b0;
	end
	else if (green)begin
		yellow <= 1'b1;
	end
	else if (red)begin
		yellow <= 1'b0;
	end
	else begin
		yellow <= yellow;
	end
end

always @(posedge clk)begin
	if (~rstn)begin
		red <= 1'b0;
	end
	else if (green)begin
		red <= 1'b0;
	end
	else if (yellow)begin
		red <= 1'b1;
	end
	else begin
		red <= red;
	end
end

endmodule
