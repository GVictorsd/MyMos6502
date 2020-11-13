	module controlreg(
		input[7:0] datain,
		input clk,rs0,rs1,rw,ca1,ca2,reset,
		output[7:0] dataout,ctrlbits);

	reg[7:0] store;

	assign ctrlbits = store;
	assign dataout = (rw & rs0 & rs1) ? store : 8'hzz;

	always@ (posedge ca1 or posedge ca2)
	begin
		store[7] = ca1 ? 1'b1 : 1'b0;
		store[6] = ca2 ? 1'b1 : 1'b0;
	end

	always @ (posedge clk)
	begin
		if(~rw & reset & rs0 & rs1)
			store = 8'h00;
		else if(~rw & rs0 & rs1)
			store = datain;
	end
	endmodule
