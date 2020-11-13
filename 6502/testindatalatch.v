	`timescale 10ns/1ns
	`include "indatalatch.v"

	module test;
	reg[7:0] datain;
	wire[7:0] databs,addrlow,addrhi;
	reg clk,wa,oadb,oaal,oaah;
	inlatch latch(datain,databs,addrlow,addrhi,clk,wa,oadb,oaal,oaah);

	initial clk = 0;
	always #2 clk = ~clk;

	initial
	begin
		datain<=8'h00; wa<=1; oadb<=0; oaal<=0; oaah<=0;
		#4 datain<=8'h52;
		#4 datain<=8'h92; wa<=0; oadb<=1;
		#4 oadb<=0; oaal<=1;
		#4 oaal<=0; oaah<=1;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end

	endmodule
