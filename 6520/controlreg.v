	module controlreg(
		input[7:0] datain,
		input clk,rs0,rs1,wa,oa,reset,
		output[7:0] dataout);

	reg[7:0] store;

	assign dataout = (oa & rs0 & rs1) ? store : 8'hzz;

	always @ (posedge clk)
	begin
		if(reset & rs0 & rs1)
			store = 8'h00;
		else if(wa & rs0 & rs1)
			store = datain;
	end
	endmodule
