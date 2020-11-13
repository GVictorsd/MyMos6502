	`timescale 10ns/1ns
	`include "pchigh.v"

	module test;
	reg[7:0] adhin;
	reg clk,adhwa,inc,pclc,adhoa,dboa;
	wire[7:0] adhout,dbout;
	pchigh dut(adhin,clk,adhwa,inc,pclc,adhoa,dboa,adhout,dbout);

	always #2 clk = ~clk;

	initial
	begin
		clk<=0; adhwa<=1; inc<=0; pclc<=0; adhoa<=0; dboa<=0;
		adhin<=8'h00;
		#4 adhwa<=0; adhoa<=1;
		#4 adhoa<=0; dboa<=1;
		#4 inc<=1; 
		#4 inc<=0; adhin<=8'h10; pclc<=1;
		#8 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end

	endmodule
