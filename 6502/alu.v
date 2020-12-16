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

	`include "adder.v"

	module alu(
	input[7:0] aIn,bIn,
	input clk,cin,sums,subs,ands,eors,ors,shftr,shftcr,decEn,reset,
	input adloa,sboa,
	input adlwa,	//temp store adl in store
	input[7:0] adlin,
	output[7:0] adl,sb,
	output cout,zero,overflow,neg);
	
	reg[7:0] store,temp;
	reg tempc1,tempc2,tempcry1;
	wire[7:0] sum1,sub1,and1,eor1,or1,shftr1,shftcr1;
	wire carry6,w1,w2;
	wire csum,csht,cshtc;

	// assign status bits...
	assign neg = net[7];
	assign zero = (net == 8'h00) ? 1'b1 : 1'b0;
	assign carry6 = add.ad1.c2;
	assign w1 = (carry6 & ~(aIn[7] | bIn[7]));
	assign w2 = ~(carry6 | ~(aIn[7] & bIn[7]));
	assign overflow = (w1 | w2);

	assign cout = decEn ? tempc2
			: (sums|subs) ? csum
			: shftr ? csht
			: shftcr ? cshtc
			: 1'bz;

	//assign results... 
	wire[7:0] tempbIn;
	adder8b add(sum1,csum,aIn,tempbIn,cin);
	assign  tempbIn = subs ? (~bIn) : bIn;

	assign and1 = ands ? aIn & bIn : 8'hzz;
	assign eor1 = eors ? aIn ^ bIn : 8'hzz;
	assign or1 = ors ? aIn | bIn : 8'hzz;
	assign {shftr1,csht} = shftr ? {aIn,1'b0} >> 1 : 8'hzz;
	assign {shftcr1,cshtc} = shftcr ? {cin,aIn,1'b0} >> 1 : 8'hzz;

	//assign data to corresponding output data lines based on control signals
	assign adl = adloa ? store : 8'hzz;
	assign sb = sboa ? store : 8'hzz;

	//logic for decimal mode...
	always@(decEn,sums,subs)
	begin
		if(decEn & (sums|subs) )
		begin
			tempc1 = 1'b0;	//carry if result of lower half excedes 0x9
			tempcry1 = 1'b0; //carry if result of lower half excedes 0xf
			tempc2 = 1'b0;	//carry if upper half excedes 0x9

			///// for first half
			if(sums)
				{tempcry1,temp[3:0]} = aIn[3:0] + bIn[3:0];
			else if(subs)
				temp[3:0] = aIn[3:0] - bIn[3:0];
			//if result excedes 0x9...
			if(temp[3] & (temp[2] | temp[1]))
			begin
				temp[3:0] = temp[3:0]-4'ha;	//calculate offset from 0xa
				tempc1 = 1'b1;	//and set carry...
			end
			
			///// for second half
			if(sums)
				temp[7:4] = aIn[7:4] + bIn[7:4] + tempcry1 + tempc1;
			else if (subs)
				temp[7:4] = aIn[7:4] - bIn[7:4] + tempc1;
			//if result excedes 0x9
			if(temp[7] & (temp[6] | temp[5]))
			begin
				temp[7:4] = temp[7:4] - 4'ha;
				tempc2 = 1'b1;
			end
		end
	end


	wire[7:0] net;
	assign net = decEn ? temp
			:(sums|subs) ? sum1
			: ands ? and1
			: eors ? eor1
			: ors ? or1
			: shftr ? shftr1
			: shftcr ? shftcr1
			: 8'hzz;
	
	always@ (negedge clk)
	begin
		if(reset)
			store <= 8'h00;
		else if(adlwa)
			store <= adlin;
		else if(decEn)
			store <= temp;
		else
			store <= net;
	end
	always@ (posedge clk)
	begin	
		if(adlwa)
			store <= adlin;
	end

	endmodule
