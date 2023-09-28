// Program Counter (Version 1.0)

module pc #(parameter D=12)(
  input logic clk, reset, jump,
  input logic[D-1:0] target,
  output logic[D-1:0] pc_out
  );
  
  always_ff @(posedge clk) begin
    if (reset)
	   pc_out <= 12'b0;
    else if (jump)
	   pc_out <= target;
	 else
		pc_out <= pc_out + 12'b1;
  end
  
endmodule