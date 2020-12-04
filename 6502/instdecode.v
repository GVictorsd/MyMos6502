	module instdecode(
		input[7:0] inst,
		input[2:0] cycle,
		input clr,
		output icyc,rcyc,scyc,
		output reg ctrlsig);

	localparam[7:0] int=8'h00,opcode1=8'hzz,opcode2=8'hxx;

	always@(*)
	begin

	if(clr)
	begin
		ctrlsig<=0;
	end

	else
	begin
		ctrlsig<=0;

		case(cycle)
			3'b000:begin
				case(inst)
					8'h00,opcode1:begin
						ctrlsig<=1;
						$display("hi");
					end
				endcase
				end
			3'b001:begin
				case(inst)
					opcode1,opcode2:begin
						ctrlsig<=0;
					end
				endcase
				end
			3'b010:begin
				case(inst)
					int,opcode2:begin 
						ctrlsig<=1;
					end
				endcase
				end
			3'b011:begin
				case(inst)
					opcode1,opcode2:begin
					end
				endcase
				end
			3'b100:begin
				case(inst)
					int,opcode2:begin
						ctrlsig<=1;
					end
				endcase
				end
			3'b101:begin
				case(inst)
					opcode1,opcode2:begin
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
	end
	endmodule
