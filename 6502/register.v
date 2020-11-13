	module register(
		inout[7:0] bus,
		input clk,wa,oa,clr);
	reg[7:0] store;

	tri[7:0] bus;
		wire[7:0] busin,busout;
		assign bus = oa ? busout : 8'hzz;
		assign busin = wa ? bus : 8'hzz;


	always@ (posedge clk)
	begin
		if(clr)
			store<= 8'h00;
		else if(wa)
			store<= busin;
	end

	assign busout= oa ? store: 8'hzz;

	endmodule
