// Register File (Version 1.2)

module reg_file (
  input logic clk,
  input logic[7:0] data_in,
  input logic write_enable,
  input logic write_direction,
  input logic[2:0] rs,
  input logic[2:0] rt,
  output logic[7:0] super_out,
  output logic[7:0] rs_out,
  output logic[7:0] rt_out				  
  );
  
  logic[7:0] super_reg;   // super register
  logic[7:0] core[8];     // 8 general purpose registers
  
  // asynchronous write
  always_ff @(posedge clk) begin
	 if(write_enable) begin
	   if (write_direction) begin
		  core[rt] <= data_in;  
//		  $display("Reg write core[%d] = %b", rt, data_in);
		end
		else begin
		  super_reg <= data_in;
//		  $display("Reg write super = %b", data_in);
		end
    end
  end
  
  // synchronous read
  assign super_out = super_reg;
  assign rs_out = core[rs];
  assign rt_out = core[rt];

endmodule