module imm_LUT (
  input       [2:0] addr,	   // target 4 values
  output logic[7:0] immediate);

  always_comb case(addr)
    3'b000: immediate = 0;   
	3'b001: immediate = 1;   
	3'b010: immediate = 2;
	3'b011: immediate = 4;   
	3'b100: immediate = 5;   
	3'b101: immediate = 7;   
	3'b110: immediate = 8'b11001100;
	3'b111: immediate = 8'b10101010;         
  endcase

endmodule

/*

	   pc = 4    0000_0000_0100	  4
	             1111_1111_1111	 -1

                 0000_0000_0011   3

				 (a+b)%(2**12)


   	  1111_1111_1011      -5
      0000_0001_0100     +20
	  1111_1111_1111      -1
	  0000_0000_0000     + 0


  */
