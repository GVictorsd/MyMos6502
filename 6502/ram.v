	/******************* RAM MODULE **********************
	* hardware for data storage...
	*
	******************************************************/

	module ram(
		input[15:0] addr,
		input rw,clk,
		inout[7:0] dout);
	reg[7:0] store[65535:0];
	
	tri[7:0] dout;
		wire[7:0] datain,dataout;
		assign dout = ~rw ? store[addr] : 8'hzz;
		assign datain = rw ? dout : 8'hzz;

	always@(posedge clk)
	begin
		if(rw)
			store[addr] <= datain;
	end
	endmodule
