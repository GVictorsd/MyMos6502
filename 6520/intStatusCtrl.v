	module intstatusctrl(
		input[7:0] ctrlreg,
		input ca1,
		inout ca2,
		output reg irq,
		output ca1out,ca2out);

	assign ca1out = ca1;
	assign ca2out = ca2;

	always@(*)
	begin
		irq = (ctrlreg[7] & ctrlreg[0]) ? 1'b1 : 1'b0;
		irq = (ctrlreg[6] & ctrlreg[3]) ? 1'b1 : 1'b0;
	end
	endmodule
