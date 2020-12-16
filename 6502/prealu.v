	/*********************** PRE-ALU ************************
	* input registers for the alu to store operands and feed
	* them to alu
	*
	********************************************************/

	module prealu(
		input[7:0] db,adl,sb,
		input dbwa,adlwa,sbwa,ldzero,clk,reset,
		output[7:0] aOut,bOut);
	reg[7:0] storeA,storeB;

	assign aOut = storeA;
	assign bOut = storeB;

	always@ (posedge clk)
	begin
		if(reset)
			storeB <= 8'h00;
		else if(dbwa)
			storeB <= db;
		else if(adlwa)
			storeB <= adl;
	end

	always@(posedge clk)
	begin
		if(reset | ldzero)
			storeA <= 8'h00;
		else if(sbwa)
			storeA <= sb;
	end
	endmodule
