	/***************** PROGRAM COUNTER LOW REGISTER ***************
	*
	*
	***************************************************************/

	module pclow(
		input[7:0] adlin,
		input adlwa,inc,setreset,setirq,setnmi,adloa,dboa,clk,
		output[7:0] dbout,adlout,
		output reg pclc);
	reg[7:0] store;

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
			{pclc,store} = store + 1;
	end

	assign dbout = dboa? store : 8'hzz;
	assign adlout = adloa? store : 8'hzz;

	endmodule
