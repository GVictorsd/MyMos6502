	module dir(
		inout[7:0] dataio,
		input[7:0] datain,
		input clk,cs1,cs2,cs3,rw,reset,
		output[7:0] dataout);
	reg[7:0] store;

	tri[7:0] dataio;
		wire[7:0] data_out,data_in;
			assign dataio = rw ? data_out : 8'hzz;
 			assign data_in = ~rw ? dataio : 8'hzz;

	assign dataio = (rw & cs1 & cs2 & ~cs3) ? datain : 8'hzz;
	assign dataout = store;

	always @(posedge clk)
	begin
		if(reset & cs1 & cs2 & ~cs3)
			store <= 8'h00;
		else if (~rw & cs1 & cs2 & ~cs3)
			store <= data_in;
	end
	endmodule
