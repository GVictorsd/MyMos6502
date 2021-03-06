	/********************* INPUT DATA LATCH *******************
	* register to store input data from the data bus
	* every phi2 clock edge and
	* output latched data to db,adl or adh
	*
	**********************************************************/

	module inlatch(
		input[7:0] datain,
		output[7:0] databs,addrlow,addrhi,
		input clk,wa,oadb,oaal,oaah);
	reg[7:0] store;

	assign databs = oadb ? store : 8'hzz;
	assign addrlow = oaal ? store : 8'hzz;
	assign addrhi = oaah ? store : 8'hzz;

	always@ (posedge clk)
	begin
		if(wa)
			store <= datain;

	end
	endmodule
