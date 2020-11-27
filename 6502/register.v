	/****************** GENERAL PURPOSE REGISTER **************
	* type-1: multiplexed data i/o bus
	* control signals: clock(clk), write enable(wa),
	* output enable(oa), clear(clr)
	**********************************************************/

	module register1(
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

	/*************** GENERAL PURPOSE REGISTER ****************
	* type-2: individual data buses (datain,dataout)
	* control signals: clock(clk), write enable(wa),
	* output enable(oa), clear(clr)
	**********************************************************/

	module register2(
		input[7:0] datain,
		input clk,wa,oa,clr,
		output[7:0] dataout);
	reg[7:0] store;

	assign dataout = oa ? store: 8'hzz;

	always@ (posedge clk)
	begin
		if(clr)
			store <= 8'h00;
		else if(wa)
			store <= datain;
	end
	endmodule
