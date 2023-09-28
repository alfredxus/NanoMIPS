// Branch Assist (Version 2.0)

module branch_assist #(parameter D=12)(
  input logic rstn,
  input logic set_lut_index,
  input logic[2:0] lut_index_in,
  input logic branch_enable,
  input logic[2:0] branch_index,
  input logic branch_not_zero,
  input logic alu_zero,
  output logic[D-1:0] pc_addr,
  output logic jump
  );
  
  
  logic[2:0] lut_index;
  
  always_latch
    if (rstn)
	   lut_index = 0;
    else if (set_lut_index)
	   lut_index = lut_index_in;
  
  always_comb begin
    if (branch_enable && branch_not_zero && !alu_zero) begin           // branch not zero
	   jump = 1'b1;
//		$display("Branch not zero to branch LUT[%d]", branch_index);
	 end
	 else if (branch_enable && !branch_not_zero && alu_zero) begin      // branch zero
	   jump = 1'b1;
//		$display("Branch zero to branch LUT[%d]", branch_index);
	end
	else
	  jump = 1'b0;
  end
  
  always_comb begin
    case(lut_index) 
      0: case(branch_index)   // program 1
        0: pc_addr = 14;
		  default: pc_addr = 0;
		endcase
		
		1: case(branch_index)   // program 3 part a
        0: pc_addr = 67;
        1: pc_addr = 19;
        2: pc_addr = 71;
		  default: pc_addr = 0;
		endcase
		
		2: case(branch_index)   // program 3 part b
        0: pc_addr = 109;
        1: pc_addr = 120;
        2: pc_addr = 132;
		  3: pc_addr = 145;
		  4: pc_addr = 93;
		  default: pc_addr = 0;
		endcase
		
		3: case(branch_index)   // program 3 part c (non-overlapping part)
        0: pc_addr = 186;
        1: pc_addr = 197;
        2: pc_addr = 209;
		  3: pc_addr = 222;
		  default: pc_addr = 0;
		endcase
		
		4: case(branch_index)   // program 3 part c (overlapping part)
        0: pc_addr = 326;
        1: pc_addr = 251;
        2: pc_addr = 275;
		  3: pc_addr = 299;
		  4: pc_addr = 323;
		  5: pc_addr = 169;
		  default: pc_addr = 0;
		endcase
		
		5: case(branch_index)   // program 2
        0: pc_addr = 14;
        1: pc_addr = 252;
        2: pc_addr = 198;
		  3: pc_addr = 247;
		  4: pc_addr = 244;
		  default: pc_addr = 0;
		endcase

		default: pc_addr = 0;
    endcase
  end
endmodule

