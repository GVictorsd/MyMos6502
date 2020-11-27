	/************************ ARITHMETIC AND LOGIC UNIT ********************
	* input: 8bit operands(aIn,bIn)
	*	clock input(clk), carry in(cin)
	*	control signals: sum, subtract(subs),and(ands),xor(eors),
	*		or(ors),shift right(shftr),shift with carry(shftcr),
	*		decimal mode enable(decEn),reset(reset)
	*		2 output enable signals(adloa,sboa)
	* output: 2 8bit bus out,
	*	status bits: carry out(cout), zero, overflow, negative(neg)...
	************************************************************************/

	module alu(
	input[7:0] aIn,bIn,
	input clk,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,reset,
	input adloa,sboa,
	output[7:0] adl,sb,
	output cout,zero,overflow,neg);
	
	reg[7:0] store,temp;
	reg tempc1,tempc2;
	wire[7:0] sum1,sub1,and1,eor1,or1,shftr1,shftcr1;
	wire carry6,w1,w2;

	// assign status bits...
	assign neg = store[7];
	assign zero = (store == 8'h00) ? 1'b1 : 1'b0;
	assign carry6 = aIn[6] & bIn[6];
	assign w1 = (carry6 & ~(aIn[7] | bIn[7]));
	assign w2 = ~(carry6 | ~(aIn[7] & bIn[7]));
	assign overflow = (w1 | w2);

	//assign results... 
	assign {cout,sum1} = (sums)&(~decEn) ? aIn + bIn: 8'hzz;
	assign {cout,sub1} = (subs)&(~decEn) ? aIn-bIn : 8'hzz;
	assign and1 = ands ? aIn & bIn : 8'hzz;
	assign eor1 = eors ? aIn ^ bIn : 8'hzz;
	assign or1 = ors ? aIn | bIn : 8'hzz;
	assign {shftr1,cout} = shftr ? {aIn,1'b0} >> 1 : 8'hzz;
	assign {shftcr1,cout} = shftcr ? {cin,aIn,1'b0} >> 1 : 8'hzz;
	assign cout = decEn ? tempc2 : 1'bz;

	//assign data to corresponding output data lines based on control signals
	assign adl = adloa ? store : 8'hzz;
	assign sb = sboa ? store : 8'hzz;

	//logic for decimal mode...
	always@(decEn,sums,subs)
	begin
		if(decEn & sums)
		begin
			tempc1 = 1'b0;
			tempc2 = 1'b0;
			temp[3:0] = aIn[3:0] + bIn[3:0];
			if(temp[3] & (temp[2] | temp[1]))
			begin
				temp[3:0] = temp[3:0]-4'ha;
				tempc1 = 1'b1;
			end
	
			temp[7:4] = aIn[7:4] + bIn[7:4] + tempc1;
			if(temp[7] & (temp[6] | temp[5]))
			begin
				temp[7:4] = temp[7:4] - 4'ha;
				tempc2 = 1'b1;
			end
		end
	end

	always@ (posedge clk)
	begin
		if(reset)
			store <= 8'h00;
		else if(decEn)
			store <= temp;
		else
			case({sums,subs,ands,eors,ors,shftr,shftcr})
				7'b1000000: store <= sum1;
				7'b0100000: store <= sub1;
				7'b0010000: store <= and1;
				7'b0001000: store <= eor1;
				7'b0000100: store <= or1;
				7'b0000010: store <= shftr1;
				7'b0000001: store <= shftcr1;
				default: store <= 8'hzz;
			endcase
	end
	endmodule
