// Top Level Design (Version 2.0)

module top_level(
  input logic clk, reset, 
  output logic done);
  
  parameter D = 12;
  
  // pc_lut output
  logic[D-1:0] jump_addr;
  
  // pc output
  logic[D-1:0] pc_val;
  
  // instruction_mem output
  logic[8:0] machine_code;
  
  // iops_mux output
  logic[2:0] branch_index;
  logic[3:0] alu_opcode;
  logic[2:0] rs;
  logic[2:0] rt;
  logic[7:0] immediate;
  logic[2:0] reg_data_source;
  logic reg_write_enable;
  logic reg_direction;
  logic select_super_reg;
  logic set_branch_lut;
  logic[2:0] branch_lut_index;
  logic branch_enable;
  logic branch_not_zero;
  logic mem_read_enable;
  logic mem_write_enable;
  
  // reg_file output
  logic[7:0] super_reg_out;
  logic[7:0] rs_out;
  logic[7:0] rt_out;
  
  // alu output
  logic[7:0] alu_output;
  logic alu_parity_out;
  logic alu_zero_out;
  
  // data_mem output
  logic[7:0] mem_output;
  
  // branch mux output
  logic jump;
  
  // super_rs mux output
  logic[7:0] super_rs_out;
  
  // reg_data_soruce mux output
  logic[7:0] reg_data_in;
  
  // parity decoder output
  logic[7:0] parity_mask;
  
  pc #(.D(D)) p_ins(
    .reset(reset),
    .clk(clk),
	 .jump(jump),
	 .target(jump_addr),
	 .pc_out(pc_val)
	 );
	 
  branch_assist #(.D(D)) ba_ins(
    .rstn(reset),
    .set_lut_index(set_branch_lut),
	 .lut_index_in(branch_lut_index),
    .branch_enable(branch_enable),
    .branch_index(branch_index),
	 .branch_not_zero(branch_not_zero),
	 .alu_zero(alu_zero_out),
	 .pc_addr(jump_addr),
	 .jump(jump)
  );
  
  instruction_mem #(.D(D)) im_ins(
    .prog_ctr(pc_val),
    .mach_code(machine_code)
  );
  
  control c_ins(
    .mach_code(machine_code),
	 .alu_opcode(alu_opcode),
	 .rs(rs),
	 .rt(rt),
	 .immediate(immediate),
	 .reg_data_source(reg_data_source),
	 .reg_write(reg_write_enable),
	 .reg_direction(reg_direction),
	 .mem_read(mem_read_enable),
	 .mem_write(mem_write_enable),
	 .branch_lut_set(set_branch_lut),
	 .branch_lut_index(branch_lut_index),
	 .branch_ready(branch_enable),
	 .branch_not_zero(branch_not_zero),
	 .branch_index(branch_index),
	 .select_super_reg(select_super_reg),
	 .done(done)
  );
  
  reg_file rf_ins(
    .clk(clk),
	 .data_in(reg_data_in),
	 .write_enable(reg_write_enable),
	 .write_direction(reg_direction),
	 .rs(rs),
	 .rt(rt),
	 .super_out(super_reg_out),
	 .rs_out(rs_out),
	 .rt_out(rt_out)
  );
  
  alu a_ins(
    .alu_opcode(alu_opcode),
	 .input0(super_rs_out),
	 .input1(rt_out),
	 .result(alu_output),
	 .zero(alu_zero_out)
  );
  
  data_mem dm_ins(
    .clk(clk),
	 .read_enable(mem_read_enable),
	 .write_enable(mem_write_enable),
	 .address(super_rs_out),
	 .data_in(rt_out),
	 .data_out(mem_output)
  );
  
  mux_reg_in_source mris_ins(
	 .alu_output(alu_output),
	 .mem_output(mem_output),
	 .immediate(immediate),
	 .parity_mask(parity_mask),
	 .sel(reg_data_source),
	 .out(reg_data_in)
  );
  
  mux_alu_input0_source mais_ins(
	 .rs_out(rs_out),
	 .super_out(super_reg_out),
	 .sel(select_super_reg),
	 .out(super_rs_out)
  );
  
  parity_decoder pd_ins(
    .data_in(super_reg_out),
    .result(parity_mask)
  );
  
endmodule