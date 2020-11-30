	`timescale 10ns/1ns
	`include "prealu.v"
	
	module test;
	reg[7:0] db,adl,sb;
	reg dbwa=0,adlwa=0,sbwa=0,clk=0,reset=0;
	wire[7:0] aout,bout;
	prealu dut(db,adl,sb,dbwa,adlwa,sbwa,clk,reset,aout,bout);

	always #2 clk = ~clk;

	initial
	begin
		db<=8'h11; adl<=8'h22; sb<=8'h33; reset<=1;
		#4 reset<=0; dbwa<=1;
		#4 dbwa<=0; adlwa<=1;
		#4 adlwa<=0; sbwa<=1;
		#4 sbwa<=0;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
