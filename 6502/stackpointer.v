	/************************ STACK-POINTER ********************
	* register that stores the lower byte of top of the stack
	* 6502 allows stack from 0x0100 to 0x01ff in memory
	* stack grows from top to lower locations in memory
	* control signal "dec" is used to decrement the register by
	* 0x1...
	***********************************************************/

	module stackpointer(
		input[7:0] sbin,
		input clk,clr,wa,dec,sboa,adloa,
		output[7:0] sbout,adlout);
	reg[7:0] store;

	assign sbout = sboa ? store : 8'hzz;
	assign adlout = adloa ? store : 8'hzz;

	always@ (posedge clk)
	begin
		//if clr set, initialise stack pointer to 8'hfa
		if(clr)
			store <= 8'hfa;
		else if(wa)
			store <= sbin;
		else if(dec)
			store <= store-1'b1;
	end
	endmodule
