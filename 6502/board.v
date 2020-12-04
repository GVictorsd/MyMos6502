	/************************* BOARD MODULE *********************
	* Connecting all the modules together
	*
	************************************************************/

	`timescale 10ns/1ns

	`include "indatalatch.v"
	`include "pclow.v"
	`include "pchigh.v"
	`include "register.v"
	`include "alu.v"
	`include "prealu.v"
	`include "statusReg.v"
	`include "stackpointer.v"
	`include "passmosfet.v"
	`include "instCtrl.v"
	`include "instdecode.v"

	module board(
		inout[7:0] dataio,
//		input clk,clr,irq,nmi,
		output[7:0] abh,abl,
		output sync,rw);
	wire[7:0] db,adl,adh,sb;
	reg  clr=0,clk=0,irq=0,nmi=0;

	//pass mosfets between adh,db and sb
	reg  adhsb=0,dbsb=0,rw=0;
	passMosfet p1(sb,adh,adhsb);
	passMosfet p2(sb,db,dbsb);

	//input data latch
	reg  dlwa=0,dldboa=0,dladloa=0,dladhoa=0;
	inlatch dl(dataio,db,adl,adh,clk,dlwa,dldboa,dladloa,dladhoa);

	//program counter low
	reg  pcladlwa=0,pclinc=0,pcladloa=0,pcldboa=0;
	wire pclc;
	pclow pcl(adl,pcladlwa,pclinc,pcladloa,pcldboa,clk,db,adl,pclc);

	//program counter high
	reg  pchadhwa=0,pchinc=0,pchadhoa=0,pchdboa=0;
	pchigh pch(adh,clk,pchadhwa,pchinc,pclc,pchadhoa,pchdboa,adh,db);

	//data output register
	reg  dorwa=0,doroa=0;
	register2 dor(db,~clk,dorwa,doroa,clr,dataio);

	//address bus high register
	reg  abhwa=0;
	register2 abhreg(adh,~clk,abhwa,1'b1,clr,abh);

	//address bus low register
	reg  ablwa=0;
	register2 ablreg(adl,~clk,ablwa,1'b1,clr,abl);

	//index registers(x and y)
	reg  xwa=0,xoa=0,ywa=0,yoa=0;
	register1 x(sb,clk,xwa,xoa,clr);
	register1 y(sb,clk,ywa,yoa,clr);

	//stack pointer
	reg  spwa=0,spsboa=0,spadloa=0,spdec=0;
	stackpointer sp(sb,clk,clr,spwa,spdec,spsboa,spadloa,sb,adl);

	//alu
	wire[7:0] aOut,bOut;
	reg  predbwa=0,preadlwa=0,presbwa=0;
	prealu pre(db,adl,sb,predbwa,preadlwa,presbwa,clk,clr,aOut,bOut);

	reg  cin=0,sums=0,subs=0,ands=0,eors=0,ors=0,shftr=0,shftcr=0,decEn=0;
	reg  aluadloa=0,alusboa=0;
	wire cout,zero,overflow,neg;
	alu Alu(aOut,bOut,clk,cin,sums,subs,ands,eors,ors,
			shftr,shftcr,decEn,clr,aluadloa,alusboa,
			adl,sb,cout,zero,overflow,neg);

	//accumulator
	reg  accwa=0,accdboa=0,accsboa=0; 
	register3 acc(sb,clk,accwa,accsboa,accdboa,clr,sb,db);

	//status register
	wire[7:0] status;
	reg  sircary=0,sirirqdis=0,sirdecmod=0,sirwa=0,saluwa=0,abuswa=0,aoa=0;
	statusreg sr(db,cout,zero,overflow,neg,sircary,sirirqdis,sirdecmod,clk,clr,sirwa,saluwa,abuswa,aoa,status,db);

	///control logic
	//instruction cycle control
	wire icyc,rcyc,scyc;
	wire[7:0] instin,instout;
	wire[2:0] cycout;
	predecodereg predecreg(dataio,clk,instin);
	instctrl ir(instin,~clk,irq,rst,icyc,rcyc,scyc,sync,instout,cycout);
	wire contsig;
	instdecode instdec(instout,cycout,clr,icyc,rcyc,scyc,contsig);


	always #2 clk = ~clk;

	initial
	begin
		//lda...
		#1 clr<=1;
		#4 clr<=0;dl.store<=8'h05;ablwa<=1;dladloa=1;
		#4 ablwa<=0;dladloa=0;dl.store<=8'h00;abhwa<=1;dladhoa=1;
		$display("%h	%h\n",abh,abl);
		#4 dl.store<=8'h00;abhwa<=0;dladhoa=0;
		#4 dldboa<=1;accwa<=1;dbsb<=1; 
		#4 dldboa<=0;accwa<=0;dbsb<=0;$display("%h",acc.store);
		
		//add...
		#4 dl.store<=8'h06;ablwa<=1;dladloa=1;
		#4 ablwa<=0;dladloa=0;dl.store<=8'h00;abhwa<=1;dladhoa=1;
		$display("%h	%h\n",abh,abl);
		#4 dl.store<=8'h0f;abhwa<=0;dladhoa=0;
		#4 dldboa<=1;predbwa=1;accsboa<=1;presbwa=1;
		#4 dldboa<=0;predbwa=0;accsboa<=0;presbwa=0;sums<=1;decEn<=1;
		$display("%h	%h",pre.storeB,pre.storeA);
		#4 sums<=0;decEn<=0;alusboa=1;accwa<=1;
		#4 $display("%h",acc.store);
		$finish;
	end
	
	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,board);
	end
	endmodule
