	module statusreg(
		input clk,reset,wa,oa,carry,zero,overflow,neg,
		input irqdis,decmode,brk,
		output[7:0] out);
	reg status;

	assign out = oa ? status : 8'hzz;

	always@ (posedge clk)
	begin
		if (reset)
			status <= 8'h00;
		else if(wa)
			status <= {neg,overflow,1'b1,brk,decmode,irqdis,zero,carry};
	end
	
	endmodule
