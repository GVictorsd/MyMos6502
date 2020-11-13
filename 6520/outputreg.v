	module outreg(
		input[7:0] datain,
		input clk,rs0,rs1,cr2,rw,reset,
		output[7:0] dataout);
	reg[7:0] store;

	assign dataout = store;

	always@ (posedge clk)
	begin
		if(reset & rs0 & rs1 & cr2 & ~rw)
			store <= 8'h00;
		else if(rs0 & rs1 & cr2 & ~rw)
			store <= datain;
	end
	endmodule
