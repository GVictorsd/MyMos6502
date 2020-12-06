	/***************** PROGRAM COUNTER LOW REGISTER ****************
	* module to store lower 8 bits of the program counter...
	* control signals: setreset,setirq,setnmi-used to set pc to
	* respective vector locations...
	* inc- increment pclow by 1 bit
	* output pclc-increment overflow bit for the pc high module
	*
	***************************************************************/

	module pclow(
		input[7:0] adlin,
		input adlwa,inc,setreset,setirq,setnmi,adloa,dboa,clk,
		output[7:0] dbout,adlout,
		output pclc);
	reg[7:0] store;

	assign pclc = (store == 8'hff & inc) ? 1'b1 : 1'b0;

	always@ (posedge clk)
	begin
		if(setreset)
			store <= 8'hfc;
		else if(setirq)
			store <= 8'hfe;
		else if(setnmi)
			store <= 8'hfa;
		else if(adlwa)
			store = adlin;
		else if(inc)
			store = store + 1;
	end

	assign dbout = dboa? store : 8'hzz;
	assign adlout = adloa? store : 8'hzz;

	endmodule
