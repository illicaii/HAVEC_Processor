// combinational -- no clock
module alu(
  input[3:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 8-bit wide data path
  output logic[7:0] rslt,
  output logic[7:0] pari     // reduction XOR (output)
);

always_comb begin 
  rslt = 'b0;
  pari = ^rslt;              
  case(alu_cmd)
    4'b0000: // bitwise OR
      rslt = inA | inB;
    4'b0001, 4'b0010: // XOR operations
    begin
      rslt = inA ^ inB;
      pari = ^rslt;
    end
    4'b0011: // ADD
      rslt = inA + inB;
    4'b0100: // decode 
      //inA is error inB is data [only one of these cases should ever be matched]
      casex(inA)
        8'b0??0?111: //d1
          rslt = inB ^ 8'b00001000;
        8'b0??1?011: //d2
          rslt = inB ^ 8'b00100000;
        8'b0??1?101: //d3
          rslt = inB ^ 8'b01000000;
        8'b0??1?111: //d4
          rslt = inB ^ 8'b10000000;
        8'b1??0?011: //d5
          rslt = inB ^ 8'b00000010;
        8'b1??0?101: //d6
          rslt = inB ^ 8'b00000100;
        8'b1??0?111: //d7
          rslt = inB ^ 8'b00001000;
        8'b1??1?001: //d8
          rslt = inB ^ 8'b00010000;
        8'b1??1?011: //d9
          rslt = inB ^ 8'b00100000;
        8'b1??1?101: //d10
          rslt = inB ^ 8'b01000000;
        8'b1??1?111: //d11
          rslt = inB ^ 8'b10000000;
        default: //two errors or parity bit: cant or dont need to fix
          rslt = inB;
      endcase

    4'b0101: // error count
      //inA is error
      if((inA[7] == 0 && inA[4] == 0 && inA[2] == 0 && inA[1] == 0 && inA[0] == 0 )) //quartus cant use inside statements :(
        rslt = 8'b00000000; //no error
      else if ((inA[7] == 1 || inA[4] == 1 || inA[2] == 1 || inA[1] == 1) && inA[0] == 0)
        rslt = 8'b10000000; //two error
      else
        rslt = 8'b01000000; //one error

    4'b0110: // bitwise AND (mask)
      rslt = inA & inB;

    4'b1000: // left shift
      rslt = inA << inB;
    4'b1001: // right shift
      rslt = inA >> inB;
    4'b1111: //pass
      rslt = inA;
    endcase
end
   
endmodule