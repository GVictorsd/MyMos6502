	/************************ STATUS REGISTER **********************
	* stores current status of the processor...
	* its an 8bit register, each bit being used as follows:
	* {Negative,Overflow,Brk,Decimal mode,Interupt request disable,
	*	Zero,Carry} 
	* these bits can be set directly from the instruction register,
	* alu or contents can be latched from the data bus...
	****************************************************************/
	
	module statusreg(
		input[7:0] busin,
		input acary,azero,aoverflow,aneg,
		input ircary,irirqdis,irdecmode,
		input clk,reset,wair,waalu,wabus,oa,
		output[7:0] out,busout);
	reg[7:0] status;

	assign busout = oa ? status : 8'hzz;
	assign out = status;

	always@ (posedge clk)
	begin
		if (reset)
			status <= 8'h00;
		
		else if(wair)
			status <= {status[7:4],irdecmode,irirqdis,status[1],ircary };

		else if(waalu) 
			status <= {aneg,aoverflow,status[5:2],azero,acary};

		else if(wabus)
			status <= busin;
	end
	
	endmodule
