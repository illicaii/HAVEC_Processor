// control decoder
module Control #(parameter opwidth = 4, mcodebits = 7)(
  input [1:0] in_type,
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, Leap, 
     MemtoReg, MemWrite, ALUSrc, RegWrite, Rslte, zeroReg,
  output logic[opwidth-1:0] ALUOp,	   // for up to 16 ALU operations
  output logic[1:0] Reg1, Reg2, out);

always_comb begin 
// defaults
  RegDst 	=   'b0;    // 1: not in place  just leave 0
  Branch 	=   'b0;    // 1: branch 
  Leap    =   'b0;    // 1: leap to branch
  MemWrite  =	'b0;    // 1: store to memory
  RegWrite  =	'b1;    // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;    // 1: load -- route memory instead of ALU to reg_file data in
  ALUSrc 	=	'b0;      // 1: immediate  0: second reg file output
  Rslte = 'b0;        //1: pari output for reduction XOR
  ALUOp = 4'b1111;    // default Op: pass (should never be reached)
  zeroReg = 'b0;      // 1: 0 reg needed
  Reg1 = 2'b00;
  Reg2 = 2'b00;
  out = 2'b00;

//decoding machine code
case(in_type)    
  2'b00:  begin					// load/store
    if(instr[6] == 'b1) begin
      MemWrite = 'b1;      // write to data mem
      RegWrite = 'b0;      // typically don't also load reg_file
      Reg1 = instr[5:4];   //take from reg specified
    end else if (instr[6] == 'b0) begin
      MemtoReg = 'b1;
      out = instr[5:4];   //send to
    end
      Reg1 = instr[5:4];   //take from reg specified
  end
  2'b01:  begin         //Shift and And
    if (instr[6:5] == 2'b11)
      ALUOp = 4'b0110; //AND instruction
    else
      ALUOp = {3'b100, 1'(instr[3])};
    Reg1 = instr[2:1];
    //no second Reg
    out = instr[0];
    ALUSrc = 'b1;
  end
  2'b10:  begin				  // ALU main opps
    ALUOp = {1'b0, 3'(instr[6:4])};
    if (3'(instr[6:4]) == 3'b001)
      Rslte = 'b1;
    case(instr[2:0])
      3'b000: begin
        Reg1 = 2'b00;
        Reg2 = 2'b01;
      end
      3'b001: begin
        Reg1 = 2'b00;
        Reg2 = 2'b10;
      end
      3'b010: begin
        Reg1 = 2'b00;
        Reg2 = 2'b11;
      end
      3'b011: begin
        Reg1 = 2'b01;
        Reg2 = 2'b10;
      end
      3'b100: begin
        Reg1 = 2'b01;
        Reg2 = 2'b11;
      end
      3'b101: begin
        Reg1 = 2'b00;
        zeroReg = 'b1;
      end
      3'b110: begin
        Reg1 = 2'b10;
        zeroReg = 'b1;
      end
      3'b111: begin
      end
    endcase

    out = {1'b0, 1'(instr[3])};
  end
  2'b11: begin          //Branch/Leap
    if (instr[6] == 1) begin
      Leap ='b1; 
      RegWrite = 'b0;
    end else begin
      Branch ='b1; 
      RegWrite = 'b0;
    end
  end
endcase

end
	
endmodule