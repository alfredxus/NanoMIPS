// Data Memory (Version 1.1)

module data_mem (
  input logic clk,
  input logic read_enable,
  input logic write_enable,
  input logic[7:0] address,
  input logic[7:0] data_in,
  output logic[7:0] data_out
  );

  logic[7:0] core[256];
  
  initial
  $readmemb("D:/School/Class/CSE141L/NanoMIPS/data_mem_p1.txt", core);
//$readmemb("D:/School/Class/CSE141L/NanoMIPS/data_mem_p2.txt", core);
//$readmemb("D:/School/Class/CSE141L/NanoMIPS/data_mem_p3.txt", core);
	  
  always_comb begin
    if (read_enable) begin
      data_out = core[address];
//		$display("Memory read M[%d] = %b", address, data_out);
	 end
    else
	   data_out = 8'bZ;
  end
  
  always_ff @(posedge clk)
    if(write_enable)	begin
      core[address] <= data_in; 
//		$display("Memory write M[%d] = %b", address, data_in);
	 end

endmodule