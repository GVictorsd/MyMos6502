	/*********************** PROGRAM COUNTER HIGH REGISTER **********
	* module to store top 8 bits of the program counter...
	* control signals: setreset,setirq,setnmi-used to set pc to
	* respective vector locations...
	* setstk-set pchigh to 0x01 for stack access
	* pclc-increment overflow bit from the pc low module
	*
	*****************************************************************/

	module pchigh(
		input[7:0] adhin,
		input clk,adhwa,setreset,setirq,setnmi,setstk,setzero,pclc,adhoa,dboa,
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
		else if(pclc)
			store<= store + 1;
	end
	
	assign adhout = setstk ? 8'h01 : 8'hzz;
	assign adhout = setzero ? 8'h00 : 8'hzz;
	assign adhout = adhoa ? store : 8'hzz;
	assign dbout = dboa ? store : 8'hzz;

	endmodule
