	/******************* PASS-MOSFETS ******************
	* module to model passmosfets between 
	* addressHighBus,specialBus and
	* dataBus,specialBus...
	* control bit (ctrl) is used to enable the mosfets
	***************************************************/

	module passMosfet(
		inout[7:0] ina,inb,
		input ctrl);

	tranif1(ina[0],inb[0],ctrl); 
	tranif1(ina[1],inb[1],ctrl); 
	tranif1(ina[2],inb[2],ctrl); 
	tranif1(ina[3],inb[3],ctrl); 
	
	tranif1(ina[4],inb[4],ctrl); 
	tranif1(ina[5],inb[5],ctrl); 
	tranif1(ina[6],inb[6],ctrl); 
	tranif1(ina[7],inb[7],ctrl); 
	
	endmodule
