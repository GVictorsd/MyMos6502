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
		adcimm=8'h69,adcabs=8'h6d,adczp=8'h65;

	
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
					//add with carry(immediate)
					adcimm,adcabs,adczp:begin
						//Write alu out to acc
						alusboa<=1;accwa<=1;
						icyc<=1;saluwa<=1;
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
					
					adcimm,adcabs,adczp:begin
						//Increment pc and load to add.bus.regs
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;icyc<=1;
						$display("adcabs1");
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
						$display("hi3");
					end
					
					adcimm:begin
						icyc<=1;
					end

					adczp:begin
						dladloa<=1;ablwa<=1;setzero<=1;
						abhwa<=1;icyc<=1;
					end
					
					adcabs:begin
						//Get data from nxt addr as operand addr lo
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						ablwa<=1;abhwa<=1;icyc<=1;
						$display("adcabs2");
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

					adcimm:begin
						//Get data from datalatch and acc to alu
						dldboa<=1;accsboa<=1;predbwa<=1;
						presbwa<=1;sums<=1;
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
					end

					adczp:begin
						icyc<=1;
					end

					adcabs:begin
						//Get data from nxt addr as operand addr hi
						dldboa<=1;aludbwa<=1;aluadloa<=1;
						dladhoa<=1;abhwa<=1;ablwa<=1;icyc<=1;
						$display("adcabs3");
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

					adcabs:begin
						icyc<=1;
						$display("adcabs4");
					end

					adczp:begin	
						//Get data from datalatch and acc to alu
						dldboa<=1;accsboa<=1;predbwa<=1;
						presbwa<=1;sums<=1;
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
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

					adcabs:begin
						//Get data from datalatch and acc to alu
						dldboa<=1;accsboa<=1;predbwa<=1;
						presbwa<=1;sums<=1;
						//Increment pc and get nxt inst
						pclinc<=1;pcladloa<=1;pchadhoa<=1;
						abhwa<=1;ablwa<=1;rcyc<=1;
						$display("adcabs5");
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
