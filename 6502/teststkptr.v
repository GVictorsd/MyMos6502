	`timescale 10ns/1ns
	`include "stackpointer.v"

	module test;
	reg[7:0] sbin;
	reg clk=0,clr=0,wa=0,dec=0,sboa=0,adloa=0;
	wire[7:0] sbout,adlout;

	stackpointer dut(sbin,clk,clr,wa,dec,sboa,adloa,sbout,adlout);
	
	always #2 clk = ~clk;

	initial
	begin
		clr<=1;sbin<=8'h68;sboa<=1;
		#4 clr<=0;dec<=1;
		#20 dec<=0;wa<=1; 
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
