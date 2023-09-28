// ALU (Version 1.1)

module alu(
  input logic[3:0] alu_opcode,
  input logic[7:0] input0, input1,
  output logic[7:0] result,
  output logic zero                // NOR (output)
  );
  
  always_comb
    zero = !result;
	 
  always_comb        
    case(alu_opcode)
      4'b0000 :
	     result = input0;           // RS/SUPER BYPASS
		4'b0001 :
		  result = input1;           // RT BYPASS
	   4'b0010 :
	     result = input0 << 1;      // LLS SUPER
	   4'b0011 :
	     result = input1 << 1;      // LLS RX
	   4'b0100 :
		  result = input0 >> 1;      // RLS SUPER
	   4'b0101 :
	     result = input1 >> 1;      // RLS RX
	   4'b0110, 4'b0111 :
	     result = input0 & input1;  // Bitwise AND
		4'b1000, 4'b1001 :
		  result = input1 | input0;  // Bitwise OR
		4'b1010 :
		  result = input0 ^ input1;  // XOR SUPER RX
		4'b1011 :
		  result = {7'b0, |input0};  // IOR SUPER
		4'b1100 :
		  result = {7'b0, ^input0};  // IXOR SUPER
		4'b1101 :
		  result = input1 - input0;  // SUB RX SUPER
		4'b1110, 4'b1111 :
		  result = input0 + input1;  // ADD
	   default:
	     result = 8'bZ;             // NOPS
    endcase

endmodule