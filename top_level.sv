module top_level(
  input        clk, reset, 
  output logic done);
  parameter D = 10,             // program counter width
    A = 4;             		      // ALU command bit width
  wire[D-1:0] target, 			    // Leap target
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		    // from RegFile
              datMem,           // from DataMem
              muxA,
              muxB, 
              muxC,
              muxD,
			        rslt,             // alu output
              immed,
              mem_addr,
              pari;
  wire  branch_en, leap_en;     // from control to PC and branching; 
  wire  MemWrite,
        MemtoReg,
        Rslte,
        zeroReg,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[1:0] rd_addrA,
            rd_addrB,
            rd_out, 
            in_type,
            sel;    // address pointers to reg_file
  wire[6:0] instr;
  wire[2:0] imm_code;

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
		      .leap_en          ,
		      .target           ,
		      .prog_ctr          );

  //mem address lookup
  assign sel = mach_code[3:2];
  MC #(.D(8)) 					
    mc1 (.reset           ,
        .clk              ,
        .leap_en          ,
        .sel              ,
        .mem_addr          );

// facilitate leaps/branches
  brancher #(.D(D))
    br1 (.reset,
         .branch_en,
         .clk,
         .prog_ctr,
         .target          );   

// lookup table for immediates
assign imm_code = mach_code[6:4];
  imm_LUT imm1(.addr(imm_code),
                  .immediate(immed));   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

assign in_type = mach_code[8:7];
assign instr = mach_code[6:0];

// control decoder
  Control ctl1(
  .in_type,
  .instr,
  .RegDst(), 
  .Branch(branch_en),
  .Leap(leap_en), 
  .MemWrite, 
  .ALUSrc, 
  .RegWrite,     
  .MemtoReg,
  .Rslte,
  .zeroReg,
  .ALUOp(alu_cmd),
  .Reg1(rd_addrA),
  .Reg2(rd_addrB),
  .out(rd_out));


  reg_file #(.pw(2)) rf1(
              .dat_in(muxA),	   // loads, most ops
              .clk         ,
              .reset,
              .wr_en   (RegWrite),
              .rd_addrA(rd_addrA),
              .rd_addrB(rd_addrB),
              .wr_addr (rd_out),      // in place operation
              .datA_out(datA),
              .datB_out(datB)); 

  assign muxA = MemtoReg? datMem : muxC;
  assign muxB = ALUSrc? immed : datB;
  assign muxC = Rslte? pari : rslt;
  assign muxD = zeroReg? 8'd0 : muxB;

  alu alu1(
          .alu_cmd(alu_cmd),
          .inA    (datA),
		      .inB    (muxD),
		      .rslt       ,
		      .pari  );  

  dat_mem dm1(
          .dat_in(datA)  ,  // from reg_file
          .clk           ,
			    .wr_en  (MemWrite), // stores
			    .addr   (mem_addr),
          .dat_out(datMem));

// Done flag
  // assign done = prog_ctr == 128; //will never get here, need to put done some other way
  done_counter #(.D(15))
    cnt1 (.leap_en,
         .clk,
         .reset,
         .done          );   

endmodule