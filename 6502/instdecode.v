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
	spwa,spsboa,spadloa,spdec,spinc,
	//alu
	predbwa,preadlwa,presbwa,preldzero,
	sums,subs,ands,eors,ors,shftr,shftcr,decEn,
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
		sbcimm=8'he9,sbcabs=8'hed,sbczp=8'he5,
		andimm=8'h29,andabs=8'h2d,andzp=8'h06,
		ldaimm=8'ha9,ldaabs=8'had,ldazp=8'ha5,
		ldximm=8'ha2,ldxabs=8'hae,ldxzp=8'ha6,
		ldyimm=8'ha0,ldyabs=8'hac,ldyzp=8'ha4,
		eorimm=8'h49,eorabs=8'h4d,eorzp=8'h45,
		oraimm=8'h09,oraabs=8'h0d,orazp=8'h05,
		cmpimm=8'hc9,cmpabs=8'hcd,cmpzp=8'hc5,
		bitabs=8'h2c,bitzp=8'h24,deczp=8'hc6,
		incabs=8'hee,inczp=8'he6,decabs=8'hce,
		inx=8'he8,iny=8'hc8,dex=8'hca,dey=8'h88,
		tax=8'haa,tay=8'ha8,tsx=8'hba,
		txa=8'h8a,txs=8'h9a,tya=8'h98,
		staabs=8'h8d,stazp=8'h85,
		pha=8'h48,php=8'h08,pla=8'h68,
		plp=8'h28,jmp=8'h4c,jsr=8'h20,
		rts=8'h60,rti=8'h40,
		sec=8'h38,sed=8'hf8,sei=8'h78,
		cli=8'h58,clc=8'h18,cld=8'hd8,
		nop=8'hea;

	
	always@(*)
	begin
	{adhsb,dbsb,rw,dldboa,dladloa,dladhoa,
	pcladlwa,pclinc,pcladloa,pcldboa,setreset,
	setirq,setnmi,pchadhwa,pchadhoa,pchdboa,
	dorwa,doroa,abhwa,ablwa,xwa,xoa,ywa,yoa,
	spwa,spsboa,spadloa,spdec,spinc,predbwa,preadlwa,
	presbwa,sums,subs,ands,eors,ors,shftr,
	shftcr,decEn,aluadloa,alusboa,aludbwa,accwa,
	accdboa,accsboa,sircary,sirirqdis,sirdecmod,
	sirwa,saluwa,abuswa,aoa,icyc,rcyc,scyc,setstk,
	sinst,setstk,setzero,preldzero} = 60'd0;

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

					jsr:begin
						pchadhwa<=1;dladhoa<=1;pcladloa<=1;ablwa<=1;
						icyc<=1;
					end

					nop:icyc<=1;

					incabs,inczp,
					decabs,deczp,staabs,
					pha,php,pla,plp,rts,
					rti:begin
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;icyc<=1;
					end
					
					adcimm,adcabs,adczp,
					sbcimm,sbcabs,sbczp,
					andimm,andabs,andzp,
					eorimm,eorabs,eorzp,
					oraimm,oraabs,orazp:begin
						//Write alu out to acc
						alusboa<=1;accwa<=1;
						icyc<=1;saluwa<=1;
					end

					ldaimm,ldaabs,ldazp,
					ldximm,ldxabs,ldxzp,
					ldyimm,ldyabs,ldyzp:begin
						icyc<=1;
					end

					cmpimm,cmpabs,cmpzp,
					bitabs,bitzp:begin
						icyc<=1; saluwa<=1;
					end

					jmp:begin
						// update the program counter
						dladhoa<=1;pchadhwa<=1;
						icyc<=1;
					end

					cli,clc,cld,
					sec,sed,sei:begin

						sirwa<=1;icyc<=1;

						if(inst == cli)	sirirqdis<=0;
						else if(inst == clc)	sircary<=0;
						else if(inst == cld)	sirdecmod<=0;

						else if(inst==sec)	sircary<=1;
						else if(inst==sed)	sirdecmod<=1;
						else if(inst==sei)	sirirqdis<=1;
					end

					tax,tay,tsx,
					txa,txs,tya,
					inx,iny,dex,
					dey:begin

						icyc<=1;
						if(inst==tax) begin
							accsboa<=1; xwa<=1;  end
						else if(inst==tay) begin
							accsboa<=1; ywa<=1;  end
						else if(inst==tsx)	begin
							spsboa<=1; xwa<=1;  end
						else if(inst==txa)	begin
							xoa<=1; accwa<=1;  end
						else if(inst==txs)	begin
							xoa<=1; spwa<=1;  end
						else if(inst==tya)	begin
							yoa<=1; accwa<=1;  end
						else if(inst==inx|inst==dex)begin
							alusboa<=1;xwa<=1;	end
						else if(inst==iny|inst==dey)begin
							alusboa<=1;ywa<=1;	end
					end

				endcase
				end

			3'b001:begin
				case(inst)
					int,jsr:begin
						//write pcl to stack
						pcldboa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end

					pha,php:begin
						//write pcl to stack
						dorwa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						spdec<=1;icyc<=1;
						if(inst == pha)
							accdboa<=1;
						if(inst == php)
							aoa<=1;
					end
					pla,plp,rts,rti:begin
						//set stack ptr to addreg
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						spinc<=1;icyc<=1;
					end

					adcimm,adcabs,adczp,
					sbcimm,sbcabs,sbczp,
					andimm,andabs,andzp,
					eorimm,eorabs,eorzp,
					oraimm,oraabs,orazp,
					ldaimm,ldaabs,ldazp,
					ldximm,ldxabs,ldxzp,
					ldyimm,ldyabs,ldyzp,
					cmpimm,cmpabs,cmpzp,
					bitabs,bitzp,
					incabs,inczp,
					decabs,deczp,
					staabs,stazp,
					jmp:begin
						//Increment pc and load to add.bus.regs
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;icyc<=1;
					end

					cli,clc,cld,
					sec,sed,sei,
					nop,tax,tay,
					tsx,txa,txs,
					tya,inx,iny,
					dex,dey:begin
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
						if(inst==inx|inst==iny|inst==dex|inst==dey)begin
							dbsb<=1;predbwa<=1;
							preldzero<=1;
							if(inst==inx)begin
								xoa<=1;sums<=1;
								sircary<=1;sirwa<=1;end
							else if(inst==iny)begin
								yoa<=1;sums<=1;
								sircary<=1;sirwa<=1;end
							else if(inst==dex)begin
								xoa<=1;subs<=1;
								sircary<=0;sirwa<=1;end
							else if(inst==dey)begin
								yoa<=1;subs<=1;
								sircary<=0;sirwa<=1;end
						end
					end

				endcase
			end
			3'b010:begin
				case(inst)
					int,jsr:begin	//reset
						//write pch to stack
						pchdboa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end

					pha,php:begin
						//write to ram...
						doroa<=1;rw<=1;
						rcyc<=1;
					end

					adcimm,andimm,ldaimm,
					eorimm,ldximm,ldyimm,
					oraimm,sbcimm,cmpimm,
					pla,plp:begin
						icyc<=1;
					end

					rts,rti:begin
						//set stack ptr to addreg
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						spinc<=1;icyc<=1;
					end


					adczp,andzp,ldazp,
					ldxzp,ldyzp,eorzp,
					orazp,sbczp,cmpzp,
					bitzp,inczp,deczp,
					stazp:begin
						dladloa<=1;ablwa<=1;setzero<=1;
						abhwa<=1;icyc<=1;
					end
					
					adcabs,andabs,ldaabs,
					ldxabs,ldyabs,eorabs,
					oraabs,sbcabs,cmpabs,
					bitabs,incabs,decabs,
					staabs,jmp:begin
						//Get data from nxt addr as operand addr lo
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;icyc<=1;
					end
				endcase
			end
			3'b011:begin
				case(inst)
					int,jsr:begin
						//write status to stack
						aoa<=1;dorwa<=1;doroa<=1;
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						rw<=1;spdec<=1;icyc<=1;
					end

					pla,plp:begin
						dldboa<=1;dbsb<=1;
						rcyc<=1;
						if(inst==pla)
							accwa<=1;
						if(inst==plp)
							abuswa<=1;
					end

					rts,rti:begin
						//write to the status register
						dldboa<=1;abuswa<=1;
						//set stack ptr to addreg
						setstk<=1;spadloa<=1;ablwa<=1;abhwa<=1;
						spinc<=1;icyc<=1;
					end

					adcimm,andimm,ldaimm,
					eorimm,ldximm,ldyimm,
					oraimm,sbcimm,cmpimm:begin
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;

						if(inst==adcimm | inst==andimm | inst==eorimm | inst==oraimm | inst==sbcimm | inst==cmpimm)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							if(inst==adcimm)	sums<=1;
							else if(inst==andimm)	ands<=1;
							else if(inst==eorimm)	eors<=1;
							else if(inst==oraimm)	ors<=1;
							else if(inst==sbcimm)	subs<=1;
							else if(inst==cmpimm)begin
								subs<=1; sirwa<=1; sircary<=0;
							end
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



					adczp,andzp,ldazp,
					ldxzp,ldyzp,eorzp,
					orazp,sbczp,cmpzp,
					bitzp,inczp,deczp,
					stazp:begin
						icyc<=1;
					end

					jmp:begin
						dladloa<=1;pcladlwa<=1;rcyc<=1;
					end

					adcabs,andabs,ldaabs,
					ldxabs,ldyabs,eorabs,
					oraabs,sbcabs,cmpabs,
					bitabs,incabs,decabs,
					staabs:begin
						//Get data from nxt addr as operand addr hi
						dldboa<=1;aludbwa<=1;aluadloa<=1;
						dladhoa<=1;abhwa<=1;ablwa<=1;icyc<=1;
/////						if(inst==staabs)begin
//////////							accdboa<=1;dorwa<=1;
//////						end
					end
				endcase
			end
			3'b100:begin
				case(inst)
					int,jsr:begin
						pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;
						icyc<=1;
					end

					rts,rti:begin
						dladhoa<=1;pchadhwa<=1;
						icyc<=1;
					end

					adcabs,andabs,ldaabs,
					ldxabs,ldyabs,eorabs,
					oraabs,sbcabs,cmpabs,
					bitabs,incabs,decabs,
					staabs:begin
						icyc<=1;
////////						if(inst == staabs)begin
							//output data and toggle rw
////							rw<=1;doroa<=1;rcyc<=1;
/////						end
					end


					inczp,deczp:begin
						icyc<=1;
						if(inst==inczp| inst==deczp)
						begin
							dldboa<=1;predbwa<=1;
							sircary<=1;sirwa<=1;preldzero<=1;
							if(inst==inczp)	sums<=1;
							else if(inst==deczp)	subs<=1;
						end
					end

					adczp,andzp,ldazp,
					ldxzp,ldyzp,eorzp,
					orazp,sbczp,cmpzp,
					bitzp:begin
						//Get data from datalatch and acc to alu
						dldboa<=1;accsboa<=1;predbwa<=1;
						presbwa<=1;
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;

						if(inst==adczp | inst==andzp | inst==eorzp | inst==orazp | inst==sbczp | inst==cmpzp | inst==bitzp)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							if(inst==adczp)	sums<=1;
							else if(inst==andzp | inst==bitzp)	ands<=1;
							else if(inst==eorzp)	eors<=1;
							else if(inst==orazp)	ors<=1;
							else if(inst==sbczp)	subs<=1;
							else if(inst==cmpzp)begin
								subs<=1; sirwa<=1; sircary<=0;
							end
						end
						//load instructions
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
					int,jsr:begin
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;
						icyc<=1;ablwa<=1;
					end

					rts,rti:begin
						dladloa<=1;pcladlwa<=1;
						rcyc<=1;
					end

					incabs,decabs,staabs:begin
						icyc<=1;
						if(inst==incabs|inst==decabs)
						begin
							dldboa<=1;predbwa<=1;
							sircary<=1;sirwa<=1;preldzero<=1;
							if(inst==incabs)	sums<=1;
							else if(inst==decabs)	subs<=1;
						end

						if(inst == staabs)begin
							//output data and toggle rw
							rw<=1;doroa<=1;rcyc<=1;
						end
					end

					inczp,deczp:begin
						// output result to sb->db->outReg
						alusboa<=1;dbsb<=1;dorwa<=1;
						rcyc<=1;
					end

					adcabs,andabs,ldaabs,
					ldxabs,ldyabs,eorabs,
					oraabs,sbcabs,cmpabs,
					bitabs:begin
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
						
						if(inst==adcabs | inst==andabs | inst==eorabs | inst==oraabs | inst==sbcabs | inst==cmpabs | inst==bitabs)
						begin
							//Get data from datalatch and acc to alu
							dldboa<=1;accsboa<=1;predbwa<=1;
							presbwa<=1;
							if(inst==adcabs)	sums<=1;
							else if(inst==andabs | inst==bitabs)	ands<=1;
							else if(inst==eorabs)	eors<=1;
							else if(inst==oraabs)	ors<=1;
							else if(inst==sbcabs)	subs<=1; 
							else if(inst==cmpabs)begin
								subs<=1; sirwa<=1; sircary<=0;
							end
						end

						// load instructions
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
					int,jsr:begin
						dladloa<=1;dladhoa<=1;pcladlwa<=1;abhwa<=1;
						icyc<=1;
						if(inst==jsr)
							rcyc<=1;
					end
					incabs,decabs:begin
						// output result to sb->db->outReg
						alusboa<=1;dbsb<=1;dorwa<=1;
						rcyc<=1;
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
