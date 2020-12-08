	/******************** INSTRUCTION AND CYCLE CONTROLLER ****************
	* inputs: dataIn- 8bit data received from the data bus
	*	clock input(clk)
	*	control signals: interrupt signal(irq),reset(rst),increment
	*		timing cycle(iCyc), skip one timing cycle(sCyc),
	*		reset cycle(rCyc)...
	*		skip instruction fetch cycle(sinst)
	* outputs: 8bit instruction(ir)
	*	3bit timing cycle
	**********************************************************************/

	`timescale 10ns/1ns

	module instctrl(
		input[7:0] dataIn,
		input clk,irq,rst,iCyc,rCyc,sCyc,sinst,
		output sync,
		output reg[7:0] ir,
		output reg[2:0] cycle);
	wire[7:0] opcode;
	wire[2:0] nxtcycle;
	reg clk1;

	always@(clk)
	begin
		#1 clk1 <= clk;
	end

	assign nxtcycle = rCyc ? 3'b000
				: iCyc ? cycle + 3'b001
				: sCyc ? cycle + 3'b010
				: cycle;

	assign opcode = (nxtcycle == 3'b001 & ~sinst) ? (irq ? 8'h00 : dataIn): ir;
	assign sync = (nxtcycle == 3'b001) ? 1'b1 : 1'b0;

	always@(posedge clk1)
	begin
		if(rst)
		begin
			cycle<=3'b000;
			ir<=8'h00;
		end

		else
		begin
			cycle <= nxtcycle;
			ir <= opcode;
		end
	end
	endmodule

	module predecodereg(
		input[7:0] datain,
		input clk,
		output[7:0] dataout);
	reg[7:0] store;

	assign dataout = store;

	always@(posedge clk) 
	begin
		store <= datain;
	end
	endmodule
