	`timescale 10ns/1ns

	module instdecode(
		input[7:0] inst,
		input[2:0] cycle,
		input clr,irq,nmi,
		output reg icyc,rcyc,scyc,sinst,
		output reg
	//pass mosfets
	adhsb,dbsb,rw,
	//input data latch
	dldboa,dladloa,dladhoa,
	//program counter low
	pcladlwa,pclinc,pcladloa,pcldboa,
	setreset,setirq,setnmi,
	//program counter high
	setstk,setzero,pchadhwa,pchadhoa,pchdboa,
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
	predbwa,preadlwa,presbwa,preldzero,
	cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,
	aluadloa,alusboa,
	aludbwa,
	//accumulator
	accwa,accdboa,accsboa,
	//status register
	sircary,sirirqdis,sirdecmod,sirwa,saluwa,abuswa,aoa);

	/***************** instruction opcodes ********************/
	localparam[7:0] 
		int=8'h00,
		adcimm=8'h69,adcabs=8'h6d,adczp=8'h65,
		andimm=8'h29,andabs=8'h2d,andzp=8'h06,
		ldaimm=8'ha9,ldaabs=8'had,ldazp=8'ha5,
		ldximm=8'ha2,ldxabs=8'hae,ldxzp=8'ha6,
		ldyimm=8'ha0,ldyabs=8'hac,ldyzp=8'ha4,
		cli=8'h58,clc=8'h18,cld=8'hd8;

	
	always@(*)
	begin
	{adhsb,dbsb,rw,dldboa,dladloa,dladhoa,
	pcladlwa,pclinc,pcladloa,pcldboa,setreset,
	setirq,setnmi,pchadhwa,pchadhoa,pchdboa,
	dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,
	spwa,spsboa,spadloa,spdec,predbwa,preadlwa,
	presbwa,cin,sums,subs,ands,eors,ors,shftr,
	shftcr,decEn,aluadloa,alusboa,aludbwa,accwa,
	accdboa,accsboa,sircary,sirirqdis,sirdecmod,
	sirwa,saluwa,abuswa,aoa,icyc,rcyc,scyc,setstk,
	sinst,setstk,setzero,preldzero} = 59'd0;

		case(cycle)
			3'b000:begin
				case(inst)
					int:begin	//reset
						if(clr) begin
							setreset<=1'b1;icyc<=1;
							sinst<=1;
						end
						else if(nmi) begin
							setnmi<=1'b1;icyc<=1'b1;
							sinst<=1'b1;
						end
						else if(irq) begin
							setirq<=1'b1;icyc<=1;
							sinst<=1;
						end
						else
							icyc<=1;
					end
					
					adcimm,adcabs,adczp,
					andimm,andabs,andzp:begin
						//Write alu out to acc
						alusboa<=1;accwa<=1;
						icyc<=1;saluwa<=1;
					end

					ldaimm,ldaabs,ldazp,
					ldximm,ldxabs,ldxzp,
					ldyimm,ldyabs,ldyzp:begin
						icyc<=1;
					end

					cli,clc,cld:begin

						sirwa<=1;icyc<=1;

						if(inst == cli)	sirirqdis<=0;
						else if(inst == clc)	sircary<=0;
						else if(inst == cld)	sirdecmod<=0;
					end

				endcase
				end

			3'b001:begin
				case(inst)
					int:begin
						//write pcl to stack
						pcldboa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end
					
					adcimm,adcabs,adczp,
					andimm,andabs,andzp,
					ldaimm,ldaabs,ldazp,
					ldximm,ldxabs,ldxzp,
					ldyimm,ldyabs,ldyzp:begin
						//Increment pc and load to add.bus.regs
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;icyc<=1;
					end

					cli,clc,cld:begin	
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
					end
				endcase
			end
			3'b010:begin
				case(inst)
					int:begin	//reset
						//write pch to stack
						pchdboa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end
					
					adcimm,andimm,ldaimm,
					ldximm,ldyimm:begin
						icyc<=1;
					end

					adczp,andzp,ldazp,
					ldxzp,ldyzp:begin
						dladloa<=1;ablwa<=1;setzero<=1;
						abhwa<=1;icyc<=1;
					end
					
					adcabs,andabs,ldaabs,
					ldxabs,ldyabs:begin
						//Get data from nxt addr as operand addr lo
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;icyc<=1;
					end
				endcase
			end
			3'b011:begin
				case(inst)
					int:begin
						//write status to stack
						aoa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end

					adcimm,andimm,ldaimm,
					ldximm,ldyimm:begin
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;

						if(inst==adcimm)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							sums<=1;
							$display("!!!!! %b!!!",adcimm);
						end

						else if(inst==andimm)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							ands<=1;
							$display("and011");
						end
						/**** load insts... *****/

						else if(inst==ldaimm | inst==ldximm | inst==ldyimm)
						begin
							dldboa<=1;dbsb<=1;

							if(inst==ldaimm)	accwa<=1;
							else if(inst==ldximm)	xwa<=1;
							else if(inst==ldyimm)	ywa<=1;
						end
					end



					adczp,andzp,ldazp,ldxzp,ldyzp:begin
						icyc<=1;
					end

					adcabs,andabs,ldaabs,ldxabs,ldyabs:begin
						//Get data from nxt addr as operand addr hi
						dldboa<=1;aludbwa<=1;aluadloa<=1;
						dladhoa<=1;abhwa<=1;ablwa<=1;icyc<=1;
					end

				endcase
			end
			3'b100:begin
				case(inst)
					int:begin
						pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;
						icyc<=1;
					end

					adcabs,andabs,ldaabs,ldxabs,ldyabs:begin
						icyc<=1;
					end

					adczp,andzp,ldazp,ldxzp,ldyzp:begin
						//Get data from datalatch and acc to alu
						dldboa<=1;accsboa<=1;predbwa<=1;
						presbwa<=1;
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;

						if(inst==adczp)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							sums<=1;
						end

						else if(inst==andzp)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							ands<=1;
						end

						else if(inst==ldazp | inst==ldxzp | inst==ldyzp)
						begin
							dldboa<=1;dbsb<=1;

							if(inst==ldazp)	accwa<=1;
							else if(inst==ldxzp)	xwa<=1;
							else if(inst==ldyzp)	ywa<=1;
						end
					end
				endcase
			end
			3'b101:begin
				case(inst)
					int:begin
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;
						icyc<=1;ablwa<=1;
					end

					adcabs,andabs,ldaabs,
					ldxabs,ldyabs:begin
						
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
						
						if(inst==adcabs)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							sums<=1;
						end

						else if(inst==andabs)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							ands<=1;
						end

						else if(inst==ldaabs | inst==ldxabs | inst==ldyabs)
						begin
							dldboa<=1;dbsb<=1;

							if(ldaabs)	accwa<=1;
							else if(ldxabs)	xwa<=1;
							else if(ldyabs) ywa<=1;
						end
					end
				endcase
			end
			3'b110:begin
				case(inst)
					int:begin
						dladloa<=1;dladhoa<=1;pcladlwa<=1;abhwa<=1;
						icyc<=1;
					end
				endcase
			end
			3'b111:begin
				case(inst)
					int:begin
						pchadhwa<=1;dladhoa<=1;pcladloa<=1;ablwa<=1;
						rcyc<=1;
					end
				endcase
			end
		endcase
	end
	endmodule
