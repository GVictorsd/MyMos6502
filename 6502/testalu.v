	`timescale 10ns/1ns
	`include "alu.v"
	
	module test;
	reg [7:0] aIn,bIn;
	reg clk=0,cin=0,sums=0,subs=0,ands=0,eors=0,ors=0,shftr=0,shftcr=0,decEn=0,reset=0,adloa=0,sboa=0;
	wire [7:0] adl,sb;
	wire cout,zero,overflow,neg;
	alu dut(aIn,bIn,clk,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,reset,adloa,sboa,adl,sb,cout,zero,overflow,neg);

	always #2 clk = ~clk;

	initial
	begin
		aIn<=8'h0f; bIn<=8'h01;
		reset<=1'b1; adloa<=1'b1;
		#4 reset<=0; sums<=1;
		#4 sums<=0; subs<=1;
		#4 subs<=0; ands<=1;
		#4 ands<=0; eors<=1;
		#4 eors<=0; ors<=1;
		#4 ors<=0; shftr<=1;
		#4 shftr<=0; shftcr<=1;
		#4 shftcr<=0; subs<=1; decEn<=1;
		#4 decEn<=0;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,dut);
	end
	endmodule
