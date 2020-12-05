	/*********************** PROGRAM COUNTER HIGH REGISTER**********
	*
	*
	*****************************************************************/

	module pchigh(
		input[7:0] adhin,
		input clk,adhwa,inc,setreset,setirq,setnmi,pclc,adhoa,dboa,
		output[7:0] adhout,dbout);
	reg[7:0] store;

	always@ (posedge clk)
	begin
		if(setreset)
			store <= 8'hff;
		else if(setirq)
			store <= 8'hff;
		else if(setnmi)
			store <= 8'hff;
		else if(adhwa)
			store<= adhin;
		else if(inc)
			store<= store + 1;
		if(pclc)
			store<= store + pclc;
	end
	
	assign adhout = adhoa ? store : 8'hzz;
	assign dbout = dboa ? store : 8'hzz;

	endmodule
