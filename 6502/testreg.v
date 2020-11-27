	`include "register.v"
	`timescale 10ns/1ns
	
	module test;
	reg[7:0] bus;
	reg clk,wa,oa,clr;
	wire[7:0] buss,busout;
//	register1 regis(buss,clk,wa,oa,clr);
	register2 dut(bus,clk,wa,oa,clr,busout);

	assign buss= ~oa ? bus:8'hzz;
	
	always #2 clk=~clk;
	
	initial
	begin
		bus<=8'h00; oa<=0; wa<=1; clk<=0; clr<=0;
		#4 bus<=8'h29; 
		#4 bus<=8'h10; wa<=0; oa<=1;
		#4 $finish;
	end

	initial
	begin
		$monitor($time,"	%h	%b	%b",buss,wa,oa);
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
