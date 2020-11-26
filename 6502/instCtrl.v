	/******************** INSTRUCTION AND CYCLE CONTROLLER ****************
	* inputs: dataIn- 8bit data received from the data bus
	*	clock input(clk)
	*	control signals: interrupt signal(irq),reset(rst),increment
	*		timing cycle(iCyc), skip one timing cycle(sCyc),
	*		reset cycle(rCyc)...
	* outputs: 8bit instruction(ir)
	*	3bit timing cycle
	**********************************************************************/

	module instctrl(
		input[7:0] dataIn,
		input clk,irq,rst,iCyc,rCyc,sCyc,
		output reg[7:0] ir,
		output reg[2:0] cycle);
	wire[7:0] opcode;
	wire[2:0] nxtcycle;

	assign nxtcycle = rCyc ? 3'b000
				: iCyc ? cycle + 3'b001
				: sCyc ? cycle + 3'b010
				: cycle;

	assign opcode = (nxtcycle==3'b001) ? (irq ? 8'h00:dataIn): ir;
	
	always@(posedge clk)
	begin
		if(rst)
		begin
			cycle<=3'b00;
			ir<=8'h00;
		end
		else
		begin
			cycle <= nxtcycle;
			ir <= opcode;
		end
	end
	endmodule
