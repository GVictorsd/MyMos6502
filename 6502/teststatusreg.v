	`timescale 10ns/1ns
	`include "statusReg.v"

	module test;
	reg clk=0,reset=0,carry=0,zero=0,overflow=0,neg=0;
	reg irqdis=0,decmode=0,brk=0;
	wire[7:0] status;
	statusreg dut(clk,reset,carry,zero,overflow,neg,irqdis,decmode,brk,status);

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
