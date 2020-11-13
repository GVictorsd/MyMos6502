	module intbuff(
		inout[7:0] perifbus,
		input[7:0] outregin,ddrin,
		output[7:0] outbus);
	
	assign outbus[0] = ~ddrin[0] ? perifbus[0] : 1'bz;
	assign outbus[1] = ~ddrin[1] ? perifbus[1] : 1'bz;
	assign outbus[2] = ~ddrin[2] ? perifbus[2] : 1'bz;
	assign outbus[3] = ~ddrin[3] ? perifbus[3] : 1'bz;
	assign outbus[4] = ~ddrin[4] ? perifbus[4] : 1'bz;
	assign outbus[5] = ~ddrin[5] ? perifbus[5] : 1'bz;
	assign outbus[6] = ~ddrin[6] ? perifbus[6] : 1'bz;
	assign outbus[7] = ~ddrin[7] ? perifbus[7] : 1'bz;

	assign perifbus[0] = ddrin[0] ? outregin[0] : 1'bz;
	assign perifbus[1] = ddrin[1] ? outregin[1] : 1'bz;
	assign perifbus[2] = ddrin[2] ? outregin[2] : 1'bz;
	assign perifbus[3] = ddrin[3] ? outregin[3] : 1'bz;
	assign perifbus[4] = ddrin[4] ? outregin[4] : 1'bz;
	assign perifbus[5] = ddrin[5] ? outregin[5] : 1'bz;
	assign perifbus[6] = ddrin[6] ? outregin[6] : 1'bz;
	assign perifbus[7] = ddrin[7] ? outregin[7] : 1'bz;

	endmodule
