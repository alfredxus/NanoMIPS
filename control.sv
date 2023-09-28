// Control (Version 2.0)

module control (
  input logic[8:0] mach_code,
  
  output logic[3:0] alu_opcode,
  output logic[2:0] rs,
  output logic[2:0] rt,
  output logic[7:0] immediate,
  output logic[2:0] reg_data_source,  // 0 = ZERO, 1 = ALU, 2 = MEM, 3 = IMM, 4 = PARITY
  output logic reg_write,
  output logic reg_direction,         // 0 write to SUPER, 1 write to RX
  output logic mem_read,
  output logic mem_write,
  output logic branch_lut_set,
  output logic[2:0] branch_lut_index,
  output logic branch_ready,
  output logic branch_not_zero,       // 0 branch zero, 1 branch not zero
  output logic[2:0] branch_index,
  output logic select_super_reg,      // 0 RS feeds into alu, 1 SUPER feeds into alu
  output logic done
  );
  
  always_comb begin
  		  alu_opcode = 4'bZ;
        rs = 3'bZ;
		  rt = 3'bZ; 
		  immediate = 8'bZ;
		  reg_data_source = 3'b000;
		  reg_write = 1'b0;
		  reg_direction = 1'bZ;
		  mem_read = 1'b0;
		  mem_write = 1'b0;
		  branch_lut_set = 1'b0;
		  branch_lut_index = 3'bZ;
		  branch_ready = 1'b0;
		  branch_not_zero = 1'bZ;
		  branch_index = 3'bZ;
		  select_super_reg = 1'bZ;
		  done = 1'b0;

    case(mach_code[8:7])
		// arithmetic
	   2'b00 : begin
		  alu_opcode = mach_code[6:3]; 
		  rt = mach_code[2:0]; 
		  reg_data_source = 3'b001;
		  reg_write = 1'b1;  
		  case(alu_opcode)
		    4'b0000,
			 4'b0010,
			 4'b0100,
			 4'b0110,
			 4'b1000,
			 4'b1010,
			 4'b1011,
			 4'b1100,
			 4'b1110 : reg_direction = 1'b0;
			 4'b0001,
			 4'b0011,
			 4'b0101,
			 4'b0111,
			 4'b1001,
			 4'b1101,
			 4'b1111 : reg_direction = 1'b1;
		  endcase
		  select_super_reg = 1'b1;
		end
		
		// load and store
		2'b01 : begin
		  case(mach_code[6])
		    1'b0 : begin            // load from data mem to reg
			   rs = mach_code[2:0];
		      rt = mach_code[5:3];
			   reg_write = 1'b1;
				reg_direction = 1'b1;
				mem_read = 1'b1;
				reg_data_source = 3'b010;
			 end
			 
		    1'b1 : begin            // store from reg to data mem
			   rs = mach_code[2:0];
		      rt = mach_code[5:3];
				reg_direction = 1'bZ;
			   mem_write = 1'b1;
			 end			 
		  endcase
		  
		  select_super_reg = 1'b0;
		end
		
		// Multipurpose
		2'b10 : begin
		  case(mach_code[6])
		    // branch
		    1'b0 : begin
				alu_opcode = 4'b0000;
				rs = {1'b0, mach_code[4:3]};
				branch_ready = 1'b1;
				
				if (mach_code[5])
				  branch_not_zero = 1'b1;     // branch not zero
				else
				  branch_not_zero = 1'b0;     // branch zero   
				  
				branch_index = mach_code[2:0];
				select_super_reg = 1'b0;
			 end
			 
          // other funtions
		    1'b1 : begin
			   case(mach_code[5:3])
				  // clear SUPER
				  3'b000 : begin
					 reg_data_source = 3'b000;
					 reg_write = 1'b1;
					 reg_direction = 1'b0;
				  end
				  
				  // clear RX
				  3'b001 : begin
					 rt = mach_code[2:0]; 
					 immediate = 8'bZ;
					 reg_data_source = 3'b000;
					 reg_write = 1'b1;
					 reg_direction = 1'b1;
				  end
				  
				  // move RX => SUPER
				  3'b010 : begin
				    alu_opcode = 4'b0001;
					 rt = mach_code[2:0]; 
					 reg_data_source = 3'b001;
					 reg_write = 1'b1;
					 reg_direction = 1'b0;
				  end
				  
				  // move SUPER => RX
				  3'b011 : begin
				    alu_opcode = 4'b0000;
					 rt = mach_code[2:0]; 
					 immediate = 8'bZ;
					 reg_data_source = 3'b001;
					 reg_write = 1'b1;
					 reg_direction = 1'b1;
				  end
				  
				  // auto
				  3'b100 : begin
					 reg_data_source = 3'b100;
					 reg_write = 1'b1;
					 reg_direction = 1'b0;
				  end
				  
				  // done
				  3'b101 : begin
					 done = 1'b1;
				  end
				  
				  // load branch lut index
				  3'b110 : begin
					 branch_lut_set = 1'b1;
					 branch_lut_index = mach_code[2:0];
				  end
				  
				  // free instruction
				  3'b111 : begin
				    // Something here
				  end
			   endcase
			 end
		  endcase
		end
		
		// load immediate
		2'b11 : begin 
		  immediate = {1'b0, mach_code[6:0]};
		  reg_data_source = 3'b011;
		  reg_write = 1'b1;
		end
    endcase
  end
endmodule