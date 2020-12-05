	`timescale 10ns/1ns
	`include "pclow.v"

	module test;
	reg[7:0] adlin;
	reg adlwa,inc,adloa,dboa,clk;
	reg setreset=0,setirq=0,setnmi=0;
	wire[7:0] dbout,adlout;
	wire pclc;
	pclow dut(adlin,adlwa,inc,setreset,setirq,setnmi,adloa,dboa,clk,dbout,adlout,pclc);

	always #2 clk = ~clk;

	initial
	begin
		adlwa<=1;inc<=0;adloa<=0;dboa<=0;clk<=0;adlin<=8'h00;
		#4 adloa<=1;
		#4 adloa<=0;dboa<=1;
		#4 inc<=1;
		#4 adlin<=8'hff;adlwa<=1;
		#4 adlwa<=0;
		#4 inc<=1;
		#4 setreset<=1;
		#4 setreset<=0;setirq<=1;
		#4 setirq<=0;setnmi<=1;
		#8 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end

	endmodule
