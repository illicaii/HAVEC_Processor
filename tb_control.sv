module c_tb;

// Inputs
  bit [1:0] in_type;
  bit [6:0] instr;    

// Outputs
  wire      RegDst, 
            Branch, 
            MemtoReg, 
            MemWrite, 
            ALUSrc, 
            RegWrite, 
            Rslte,
            zeroReg;
  wire [3:0]  ALUOp;	  
  wire [1:0]  Reg1, 
              Reg2, 
              out;

	// Instantiate the Unit Under Test (UUT)
  Control uut (
    .in_type,
    .instr,
    .RegDst, 
    .Branch, 
    .MemWrite, 
    .ALUSrc, 
    .RegWrite,     
    .MemtoReg,
    .Rslte,
    .zeroReg,
    .ALUOp,
    .Reg1,
    .Reg2,
    .out);

initial begin
// Wait 100 ns for global reset to finish
  #100ns;
        
// Add stimulus here
  in_type = 2'b00;
  instr = 7'b0101010;

// load
  #20ns    instr = 7'b0011111;
// store
  #20ns    instr = 7'b0011111;


  #20ns    in_type = 2'b01;
//LSL
  #20ns    instr = 7'b1010011; // O2 = O2 << 7
//LSR
  #20ns    instr = 7'b1011011; // O2 = O2 >> 7
//AND mask
  #20ns    instr = 7'b1110011; // O2 = MASK2 AND O2


  #20ns    in_type = 2'b10;
//OR
  #20ns    instr = 7'b0001000;  //OR O2 O1 O2
//Logic XOR
  #20ns    instr = 7'b0011001;  //LXOR O2 O1 L1
//Bitwise XOR
  #20ns    instr = 7'b0101010;  //BXOR O2 O1 L2
//ADD
  #20ns    instr = 7'b0111011;  //ADD O2 O2 L1
//Decode
  #20ns    instr = 7'b1001100;  //DCD O2 O2 L2
//Error count
  #20ns    instr = 7'b1011100;  //ECNT O2 O2 L2
//reg AND
  #20ns    instr = 7'b1101000;  //RAND O2 O1 O2

//reg combination test
//r1 r2
  #20ns    instr = 7'b0001000;
//r1 l1
  #20ns    instr = 7'b0001001;
//r1 l2
  #20ns    instr = 7'b0001010;
//r2 l1
  #20ns    instr = 7'b0001011;
//r2 l2
  #20ns    instr = 7'b0001100;
//r1 -  (should only be used with XOR)
  #20ns    instr = 7'b0011101;
//r2 -  (should only be used with XOR)
  #20ns    instr = 7'b0011110;


  #20ns    in_type = 2'b11;
//Branch
  #20ns    instr = 7'b0000000;
//Leap
  #20ns    instr = 7'b1000000;
  #20ns    instr = 7'b1001101; //garbage data


end

endmodule

