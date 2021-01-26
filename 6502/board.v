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
	wire  spwa,spsboa,spadloa,spdec,spinc;
	stackpointer sp(sb,clk,clr,spwa,spdec,spinc,spsboa,spadloa,sb,adl);

	//alu
	wire[7:0] aOut,bOut;
	wire  predbwa,preadlwa,presbwa,preldzero;
	wire  sums,subs,ands,eors,ors,shftr,shftcr,decEn;
	wire  aluadloa,alusboa;
	wire cout,zero,overflow,neg;
	wire aludbwa;
	prealu pre(db,adl,sb,predbwa,preadlwa,presbwa,preldzero,clk,clr,aOut,bOut);
	alu Alu(aOut,bOut,clk,status[0],sums,subs,ands,eors,ors,
			shftr,shftcr,decEn,clr,aluadloa,alusboa,aludbwa,
			db,adl,sb,cout,zero,overflow,neg);

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
	instdecode instdec(instout,cycout,clr,irq,nmi,icyc,rcyc,scyc,sinst,adhsb,dbsb,rw,dldboa,dladloa,dladhoa,pcladlwa,pclinc,pcladloa,pcldboa,setreset,setirq,setnmi,setstk,setzero,pchadhwa,pchadhoa,pchdboa,dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,spwa,spsboa,spadloa,spdec,spinc,predbwa,preadlwa,presbwa,preldzero,sums,subs,ands,eors,ors,shftr,shftcr,decEn,aluadloa,alusboa,aludbwa,accwa,accdboa,accsboa,sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa);

	always #2 clk = ~clk;

	initial
	begin
		$monitor("******* %8h",rm.store[16'h00]);
		#1 clr<=1;
		#4 clr<=0;
		rm.store[16'hfffc]<=8'h57;
		rm.store[16'hfffd]<=8'h28;

		rm.store[16'h2857]<=8'h4c;
		rm.store[16'h2858]<=8'ha3;
		rm.store[16'h2859]<=8'ha2;
//		rm.store[16'h2223]<=8'h01;
		acc.store<=8'h00;
		x.store<=8'hdd;
		#100 $finish;
	end

	always@(acc.store)begin
		$display("acc:  	 %8h",acc.store);
	end

	initial
	begin
		$dumpfile("vars.vcd");
		$dumpvars(0,board);
	end


	endmodule
