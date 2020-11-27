	module statusreg(
		input clk,reset,carry,zero,overflow,neg,
		input irqdis,decmode,brk,
		output reg[7:0] status);
	always@ (posedge clk)
	begin
		if (reset)
			status <= 8'h00;
		else
			status <= {neg,overflow,1'b1,brk,decmode,irqdis,zero,carry};
	end
	endmodule
