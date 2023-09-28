// Parity Decoder (Version 1.0)

module parity_decoder(
  input logic[7:0] data_in,
  output logic[7:0] result
  );

  always_comb begin
    // P8 P4 P2 P1  
    case(data_in[3:0])
	   4'b0011 : result = 8'b00000001;   // bit 1
	   4'b0101 : result = 8'b00000010;   // bit 2
		4'b0110 : result = 8'b00000100;   // bit 3
		4'b0111 : result = 8'b00001000;   // bit 4
		4'b1001 : result = 8'b00010000;   // bit 5
		4'b1010 : result = 8'b00100000;   // bit 6
		4'b1011 : result = 8'b01000000;   // bit 7
		4'b1100 : result = 8'b10000000;   // bit 8
		4'b1101 : result = 8'b10000001;   // bit 9
		4'b1110 : result = 8'b10000010;   // bit 10
		4'b1111 : result = 8'b10000100;   // bit 11
		default : result = 8'b00000000;
    endcase
  end
   
endmodule