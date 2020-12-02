	`timescale 10ns/1ns
	`include "statusReg.v"

	module test;
	
	reg [7:0] busin;
	reg acary=0,azero=0,aoverflow=0,aneg=0;
	reg ircary=0,irirqdis=0,irdecmode=0;
	reg clk=0,reset=0,wair=0,waalu=0,wabus=0,oa=0;
	wire[7:0] status;
	statusreg dut(
		busin,
		acary,azero,aoverflow,aneg,
		ircary,irirqdis,irdecmode,
		clk,reset,wair,waalu,wabus,oa,
		status);

	always #2 clk = ~clk;

	initial
	begin
		reset <= 1;
		#4 reset <=0; carry<=1;neg<=1; decmode<=1;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	
	endmodule
