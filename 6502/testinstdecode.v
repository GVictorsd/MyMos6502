	`timescale 10ns/1ns
	`include "instdecode.v"

	module test;
	reg[7:0] inst;
	reg[2:0] cyc;
	reg clr=0;
	wire icyc,rcyc,scyc,res;

	instdecode dut(inst,cyc,clr,icyc,rcyc,scyc,res);

	initial
	begin
		inst<=8'h00;cyc<=3'b000;
		#2 cyc<=3'b001;
		#2 cyc<=3'b010;
		#2 cyc<=3'b011;
		#2 cyc<=3'b100;
		#2 cyc<=3'b101;
		#2 cyc<=3'b110;
		#2 cyc<=3'b111;
		#2 $finish;
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,test);
	end
	endmodule
