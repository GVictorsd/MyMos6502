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
	`include "ram.v"

	module board(
//		inout[7:0] dataio,
//		input clk,clr,irq,nmi,
//		output[7:0] abh,abl,
		output sync,rw);

	wire[7:0] db,adl,adh,sb;
	reg  clr=0,clk=0,irq=0,nmi=0;
	

	wire[7:0] dataio,abh,abl;
	ram rm({abh,abl},rw,clk,dataio);

	
	//pass mosfets between adh,db and sb
	wire  adhsb,dbsb,rw;
	passMosfet p1(sb,adh,adhsb);
	passMosfet p2(sb,db,dbsb);

	//input data latch
	wire  dldboa,dladloa,dladhoa;
	inlatch dl(dataio,db,adl,adh,clk,1'b1,dldboa,dladloa,dladhoa);

	//program counter low
	wire  pcladlwa,pclinc,pcladloa,pcldboa;
	wire setreset,setirq,setnmi,setstk,setzero;
	wire pclc;
	pclow pcl(adl,pcladlwa,pclinc,setreset,setirq,setnmi,pcladloa,pcldboa,clk,db,adl,pclc);

	//program counter high
	wire  pchadhwa,pchadhoa,pchdboa;
	pchigh pch(adh,clk,pchadhwa,setreset,setirq,setnmi,setstk,setzero,pclc,pchadhoa,pchdboa,adh,db);

	//data output register
	wire  dorwa,doroa;
	register2 dor(db,~clk,dorwa,doroa,clr,dataio);

	//address bus high register
	wire  abhwa;
	register2 abhreg(adh,~clk,abhwa,1'b1,clr,abh);

	//address bus low register
	wire  ablwa;
	register2 ablreg(adl,~clk,ablwa,1'b1,clr,abl);

	//index registers(x and y)
	wire  xwa,xoa,ywa,yoa;
	register1 x(sb,clk,xwa,xoa,clr);
	register1 y(sb,clk,ywa,yoa,clr);

	//stack pointer
	wire  spwa,spsboa,spadloa,spdec;
	stackpointer sp(sb,clk,clr,spwa,spdec,spsboa,spadloa,sb,adl);

	//alu
	wire[7:0] aOut,bOut;
	wire  predbwa,preadlwa,presbwa,preldzero;
	wire  cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn;
	wire  aluadloa,alusboa;
	wire cout,zero,overflow,neg;
	wire aluadlwa;
	prealu pre(db,adl,sb,predbwa,preadlwa,presbwa,preldzero,clk,clr,aOut,bOut);
	alu Alu(aOut,bOut,clk,cin,sums,subs,ands,eors,ors,
			shftr,shftcr,decEn,clr,aluadloa,alusboa,aluadlwa,
			adl,adl,sb,cout,zero,overflow,neg);

	//accumulator
	wire  accwa,accdboa,accsboa; 
	register3 acc(sb,clk,accwa,accsboa,accdboa,clr,sb,db);

	//status register
	wire[7:0] status;
	wire  sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa;
	statusreg sr(db,cout,zero,overflow,neg,sircary,sirirqdis,sirdecmod,clk,clr,sirwa,saluwa,abuswa,aoa,status,db);

	///control logic
	//instruction cycle control
	wire icyc,rcyc,scyc,sinst;
	wire[7:0] instin,instout;
	wire[2:0] cycout;
	predecodereg predecreg(dataio,clk,instin);
	instctrl ir(instin,~clk,irq,clr,icyc,rcyc,scyc,sinst,sync,instout,cycout);
	wire contsig;
	instdecode instdec(instout,cycout,clr,irq,nmi,icyc,rcyc,scyc,sinst,adhsb,dbsb,rw,dldboa,dladloa,dladhoa,pcladlwa,pclinc,pcladloa,pcldboa,setreset,setirq,setnmi,setstk,setzero,pchadhwa,pchadhoa,pchdboa,dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,spwa,spsboa,spadloa,spdec,predbwa,preadlwa,presbwa,preldzero,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,aluadloa,alusboa,aluadlwa,accwa,accdboa,accsboa,sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa);

	always #2 clk = ~clk;

	initial
	begin
		#1 clr<=1;
		#4 clr<=0;
		rm.store[16'hfffc]<=8'h57;
		rm.store[16'hfffd]<=8'h28;
		rm.store[16'h2857]<=8'h69;
		rm.store[16'h2858]<=8'h47;
		acc.store<=8'h12;
		#100 $finish;
	end
/*	initial
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
*/
	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,board);
	end
	endmodule
