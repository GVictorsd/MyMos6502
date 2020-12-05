	`timescale 10ns/1ns

	module instdecode(
		input[7:0] inst,
		input[2:0] cycle,
		input clr,irq,nmi,
		output reg icyc,rcyc,scyc,
		output reg
	//pass mosfets
	adhsb,dbsb,rw,
	//input data latch
	dlwa,dldboa,dladloa,dladhoa,
	//program counter low
	pcladlwa,pclinc,pcladloa,pcldboa,
	setreset,setirq,setnmi,
	//program counter high
	pchadhwa,pchinc,pchadhoa,pchdboa,
	//data output register
	dorwa,doroa,
	//address bus high register
	abhwa,
	//address bus low register
	ablwa,
	//index registers(x and y)
	xwa,xoa,ywa,yoa,
	//stack pointer
	spwa,spsboa,spadloa,spdec,
	//alu
	predbwa,preadlwa,presbwa,
	cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,
	aluadloa,alusboa,
	//accumulator
	accwa,accdboa,accsboa,
	//status register
	sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa);

//////	reg[52:0] ctrlsig = {adhsb,dbsb,rw,dlwa,dldboa,dladloa,dladhoa,pcladlwa,pclinc,pcladloa,pcldboa,setreset,setirq,setnmi,pchadhwa,pchinc,pchadhoa,pchdboa,dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,spwa,spsboa,spadloa,spdec,predbwa,preadlwa,presbwa,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,aluadloa,alusboa,accwa,accdboa,accsboa,sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa};
	
	localparam[7:0] int=8'h00,opcode1=8'hzz,opcode2=8'hxx;
/*
	always@(*)
	begin

	if(clr)
	begin
	$display("hi there");
	{adhsb,dbsb,rw,dlwa,dldboa,dladloa,dladhoa,pcladlwa,pclinc,pcladloa,pcldboa,setreset,setirq,setnmi,pchadhwa,pchinc,pchadhoa,pchdboa,dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,spwa,spsboa,spadloa,spdec,predbwa,preadlwa,presbwa,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,aluadloa,alusboa,accwa,accdboa,accsboa,sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa,icyc,rcyc,scyc} = 57'd0;
	setreset = 1'b1;
	end

	else
*/	always@(*)
	begin
	{adhsb,dbsb,rw,dlwa,dldboa,dladloa,dladhoa,pcladlwa,pclinc,pcladloa,pcldboa,setreset,setirq,setnmi,pchadhwa,pchinc,pchadhoa,pchdboa,dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,spwa,spsboa,spadloa,spdec,predbwa,preadlwa,presbwa,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,aluadloa,alusboa,accwa,accdboa,accsboa,sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa,icyc,rcyc,scyc} = 57'd0;

		case(cycle)
			3'b000:begin
				case(inst)
					int:begin	//reset
						scyc<=1'b1;
						if(clr)
							setreset<=1'b1;
						else if(nmi) 
							setnmi<=1'b1;
						else if(irq) 
							setirq<=1'b1;
						$display("hi1");
					end
				endcase
				end
			3'b001:begin
				case(inst)
					opcode1,opcode2:begin
					end
				endcase
				end
			3'b010:begin
				case(inst)
					int:begin	//reset
						pcldboa<=1;dorwa<=1;doroa<=1;
						spadloa<=1;ablwa<=1;rw<=1;
						spdec<=1;icyc<=1;
						$display("hi2");
					end
				endcase
				end
			3'b011:begin
				case(inst)
					int:begin
						pchdboa<=1;dorwa<=1;doroa<=1;
						spadloa<=1;ablwa<=1;rw<=1;
						spdec<=1;icyc<=1;
						$display("hi3");
					end
				endcase
				end
			3'b100:begin
				case(inst)
					int:begin
						aoa<=1;dorwa<=1;doroa<=1;
						spadloa<=1;ablwa<=1;rw<=1;
						spdec<=1;icyc<=1;
						$display("hi4");
					end
				endcase
				end
			3'b101:begin
				case(inst)
					int:begin
						pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;
						rcyc<=1;
						$display("hi5");
					end
				endcase
				end
			3'b110:begin
				case(inst)
					opcode1,opcode2:begin
					end
				endcase
				end
			3'b111:begin
				case(inst)
					opcode1,opcode2:begin
					end
				endcase
				end
		endcase
	end
//	end
	endmodule
