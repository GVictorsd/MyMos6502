	module pchigh(
		input[7:0] adhin,
		input clk,adhwa,inc,pclc,adhoa,dboa,
		output[7:0] adhout,dbout);
	reg[7:0] store;

	always@ (posedge clk)
	begin
		if(adhwa)
			store<= adhin;
		else if(inc)
			store<= store + 1;
		if(pclc)
			store<= store + pclc;
	end
	
	assign adhout = adhoa ? store : 8'hzz;
	assign dbout = dboa ? store : 8'hzz;

	endmodule
