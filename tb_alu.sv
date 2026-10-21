module ALU_tb;

// Inputs
  bit [3:0] alu_cmd;
  bit [7:0] inA;
  bit [7:0] inB;

// Outputs
  wire [7:0] rslt;
  wire        pari;

	// Instantiate the Unit Under Test (UUT)
  alu uut (
		.alu_cmd, 
		.inA, 
		.inB, 
		.rslt, 
		.pari 
	);

initial begin
// Wait 100 ns for global reset to finish
  #100ns;
        
// Add stimulus here
  inA = 8'b00000000;
  inB = 8'b10101010;

// bit OR
  #20ns  alu_cmd = 4'b0000;
  inA = 8'b00000010;
  inB = 8'b10001010;

// bit XOR (and logical XOR)
  #20ns  alu_cmd = 4'b0001;
  inA = 8'b10101010;
  inB = 8'b00000000;
  //BXOR should be 0
  #20ns inA = 8'b1010010;
  inB = 8'b00000000;
  //BXOR should be 1
  #20ns inA = 8'b10100000;
  inB = 8'b01000000;
  //BXOR should still be 1
  #20ns inA = 8'b11111111;

// ADD
  #20ns  alu_cmd = 4'b0011;
         inA = 8'b00000101; //adding arbitrary
         inB = 8'b10101010;
  #20ns  inA = 8'b00000001; //adding 16 
         inB = 8'b00001111;
  #20ns  inA = 8'b00000000; //adding 30
         inB = 8'b00011110;
  #20ns  inA = 8'b00000000; //adding 30
         inB = 8'b00011110;

// Decode MSW
  #20ns  alu_cmd = 4'b0100;
        inB = 8'b00000000;     
// d11
#20ns inA = 8'b10010111;
// d10
#20ns inA = 8'b10010101;
// d9
#20ns inA = 8'b10010011;
// d8
#20ns inA = 8'b10010001;
// d7
#20ns inA = 8'b10000111;
// d6
#20ns inA = 8'b10000101;
// d5
#20ns inA = 8'b10000011;

// Decode LSW
// d4
#20ns inA = 8'b00010111;
// d3
#20ns inA = 8'b00010101;
// d2
#20ns inA = 8'b00010011;
// d1
#20ns inA = 8'b00000111;

// two errors or parity error (should do nothing)
#20ns inA = 8'b00000001;     //two errors

//throwaway bits with 1s;
#20ns inA = 8'b01101000; //should do nothing

// error count
  #20ns  alu_cmd = 4'b0101;
        inA = 8'b10000001;     //One error
  #20ns inA = 8'b00010001;
  #20ns inA = 8'b00000101;
  #20ns inA = 8'b00000011;
  #20ns inA = 8'b00000001;     //p0

  //different bit error combos
  #20ns inA = 8'b10010111;
  #20ns inA = 8'b10010101;
  #20ns inA = 8'b10010011;
  #20ns inA = 8'b10010001;
  #20ns inA = 8'b10010001;
  #20ns inA = 8'b10000111;
  #20ns inA = 8'b10000101;
  #20ns inA = 8'b10000011;
  #20ns inA = 8'b00010111;
  #20ns inA = 8'b00010101;
  #20ns inA = 8'b00010011;
  #20ns inA = 8'b00000111;

  #20ns inA = 8'b00000000;     //No Error
  #20ns inA = 8'b01000000;
  #20ns inA = 8'b00100000;
  #20ns inA = 8'b00001000;

  #20ns inA = 8'b00000010;     //two errors
  #20ns inA = 8'b00000100;
  #20ns inA = 8'b00010000;
  #20ns inA = 8'b10000000;
  #20ns inA = 8'b00000110;
  #20ns inA = 8'b00001110;
  #20ns inA = 8'b10000110;
  //this should be sufficient

//AND (only two masks needed)
  #20ns  alu_cmd = 4'b0110;
         inA = 8'b00000000;
         inB = 8'b11001100;
  #20ns  inA = 8'b11111111;
         inB = 8'b10101010;
 
//Left shift
  #20ns  alu_cmd = 4'b1000;
   inA = 8'b00000001;
  #20ns inB = 8'b00000001;
  #20ns inB = 8'b00000010;
  #20ns inB = 8'b00000100;
  #20ns inB = 8'b00000101;
  #20ns inB = 8'b00000111;
  #20ns inB = 8'b00000000;

//right shift
  #20ns  alu_cmd = 4'b1001;
   inB = 8'b00000001;
  #20ns inB = 8'b00000001;
  #20ns inB = 8'b00000010;
  #20ns inB = 8'b00000100;
  #20ns inB = 8'b00000101;
  #20ns inB = 8'b00000111;
  #20ns inB = 8'b00000000;

end

endmodule

