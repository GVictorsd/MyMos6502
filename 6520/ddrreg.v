	module ddr(
		input[7:0] datain,
		input clk,rs0,rs1,cr2,rw,reset,
		output[7:0] dataout,outbus);
	reg[7:0] store;

	assign dataout = store;
	assign outbus = (rw & rs0 & rs1 & cr2) ? store : 8'hzz;

	always@ (posedge clk)
	begin
		if(reset & rs0 & rs1 & cr2)
			store <= 8'h00;
		else if(~rw & rs0 & rs1 & cr2)
			store <= datain;
	end
	endmodule
