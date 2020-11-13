	module rwcontrol(
		input cs1,cs2,cs3,rs0,rs1,rw,enable,reset,
		output reg clk,rs0out,rs1out,rwout,resetout,
			ctrla,ctrlb);

	always@ (*)
	begin
		if(cs1 & cs2 & ~cs3)
		begin
			clk <= enable;
			rs0out <= rs0;
			rs1out <= rs1;
			rwout <= rw;
			resetout <= reset;
			ctrla <= (rs0 & ~rs1) ? 1 : 0;
			ctrlb <= (rs0 & rs1) ? 1 : 0;
		end
	end
	endmodule

