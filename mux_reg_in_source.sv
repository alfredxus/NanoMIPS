// Reg Input Souruce MUX (Version 1.0)

module mux_reg_in_source(
  input logic[7:0] alu_output, mem_output, immediate, parity_mask,
  input logic[2:0] sel, 
  output logic[7:0] out
  );

  always_comb begin
    case(sel)
	   3'b000 : out = 8'b0;
		3'b001 : out = alu_output;
	   3'b010 : out = mem_output;
		3'b011 : out = immediate;
		3'b100 : out = parity_mask;
		default : out = 8'b0;
	 endcase
  end
 
endmodule