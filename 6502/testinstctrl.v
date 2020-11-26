	`timescale 10ns/1ns
	`include "instCtrl.v"
	module test;
	reg [7:0] dataIn;
	reg clk=0,irq=0,rst=0,iCyc=0,rCyc=0,sCyc=0;
	wire[7:0] ir;
	wire[2:0] cycle;
	instctrl dut(dataIn,clk,irq,rst,iCyc,rCyc,sCyc,ir,cycle);
	
	always #2 clk=~clk;

	initial
	begin
		dataIn<=8'h43; rst<=1;
		#4 rst<=0; iCyc<=1;
		#8 iCyc<=0; sCyc<=1;
		#4 sCyc<=0; rCyc<=1;
		#4 rCyc<=0; iCyc<=1;
		#4 iCyc<=0; irq<=1;
		#4 irq<=0;
		#4 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,dut);
	end
	endmodule
