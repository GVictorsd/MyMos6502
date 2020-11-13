	module pclow(
		input[7:0] adlin,
		input adlwa,inc,adloa,dboa,clk,
		output[7:0] dbout,adlout,
		output reg pclc);
	reg[7:0] store;

	always@ (posedge clk)
	begin
		if(adlwa)
			store = adlin;
		else if(inc)
			{pclc,store} = store + 1;
	end

	assign dbout = dboa? store : 8'hzz;
	assign adlout = adloa? store : 8'hzz;

	endmodule
