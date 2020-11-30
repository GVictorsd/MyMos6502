	`include "indatalatch.v"
	`include "pclow.v"
	`include "pchigh.v"
	`include "register.v"
	`include "alu.v"
	`include "prealu.v"
	`include "statusReg.v"

	module board(
		inout[7:0] dataio,
		input clki,
		output[7:0] abh,abl);
	wire[7:0] db,adl,adh,sb;
	wire clr;

	//input data latch
	wire dlwa,dldboa,dladloa,dladhoa;
	inlatch dl(dataio,db,adl,adh,clk,dlwa,dldboa,dladloa,dladhoa);

	//program counter low
	wire pcladlwa,pclinc,pcladloa,pcldboa,pclc;
	pclow pcl(adl,pcladlwa,pclinc,pcladloa,pcldboa,clk,db,adl,pclc);

	//program counter high
	wire pchadhwa,pchinc,pchadhoa,pchdboa;
	pchigh pch(adh,clk,pchadhwa,pchinc,pclc,pchadhoa,pchdboa,adh,db);

	//data output register
	wire dorwa,doroa;
	register2 dor(db,clk,dorwa,doroa,clr,dataio);

	//address bus high register
	wire abhwa;
	register2 abhreg(adh,clk,abhwa,1'b1,clr,abh);

	//address bus low register
	wire ablwa;
	register2 ablreg(adl,clk,ablwa,1'b1,clr,abl);

	//index registers(x and y)
	wire xwa,xoa,ywa,yoa;
	register1 x(sb,clk,xwa,xoa,clr);
	register1 y(sb,clk,ywa,yoa,clr);

	//stack pointer
	wire spwa,spsboa,spadloa;
	register3 sp(sb,clk,spwa,spsboa,spadloa,clr,sb,adl);

	//alu
	wire[7:0] aOut,bOut;
	wire predbwa,preadlwa,presbwa;
	prealu pre(db,adl,sb,predbwa,preadlwa,presbwa,clk,clr,aOut,bOut);

	wire cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn;
	wire aluadloa,alusboa,cout,zero,overflow,neg;
	alu Alu(aOut,bOut,clk,cin,sums,subs,ands,eors,ors,
			shftr,shftcr,decEn,clr,aluadloa,alusboa,
			adl,sb,cout,zero,overflow,neg);

	//accumulator
	wire accwa,accdboa,accsboa;
	register3 acc(sb,clk,accwa,accsboa,accdboa,clr,sb,db);

	//status register
	reg[7:0] status;
	wire srwa,sroa,irqdis,brk;
	statusreg sr(clk,clr,srwa,sroa,cout,zero,overflow,neg,irqdis,decEn,brk,db);
	endmodule
