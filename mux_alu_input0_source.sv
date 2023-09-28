// Reg Out Source Mux (Version 1.0)

module mux_alu_input0_source(
  input logic[7:0] rs_out, super_out, 
  input logic sel, 
  output logic[7:0] out
  );

  always_comb begin
    if(sel == 0)
	   out = rs_out;
    else
      out = super_out; 
  end
 
endmodule