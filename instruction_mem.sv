// Instruction Memory (Version 1.0)

module instruction_mem #(parameter D=12)(
  input logic[D-1:0] prog_ctr,
  output logic[8:0] mach_code
  );

  logic[8:0] core[2**D];
  
  initial
  $readmemb("D:/School/Class/CSE141L/NanoMIPS/mach_code_p1.txt", core);
//  $readmemb("D:/School/Class/CSE141L/NanoMIPS/mach_code_p2.txt", core);
//  $readmemb("D:/School/Class/CSE141L/NanoMIPS/mach_code_p3.txt", core);

  always_comb mach_code = core[prog_ctr];

endmodule