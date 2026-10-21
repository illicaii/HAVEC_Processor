// creates machine code from assembly script
module compile_ClosestPair;
													  
string       line;
logic[7:0]   line_hex[16];
logic[7:0]   char[16];
logic[4:0]   arg;
logic[31:0]  num;
logic[7:0]   rest[10];
logic[7:0]      out_reg[2];
logic[7:0]      destination[2];
logic[7:0]      addr[7];
logic[7:0]      reg_1[2];
logic[7:0]      reg_2[2];
logic[7:0]      immediate;
logic[7:0]      mask;
logic[8:0]      machine_code;
logic[2:0]      log_code;
logic[2:0]      log_codemask;
logic[2:0]      reg_comb;
logic[2:0]      dest;
string       charw;
typedef enum {LOAD, STOR, LSL, LSR, AND, OR, LXOR, BXOR, ADD, DCD, ECNT, RAND, BRAN, LEAP, EMPTYLINE} inst;
inst         mach;
initial begin  :iloop
  static integer field_id  = $fopen("assembly.txt","r");
  static integer mach_code = $fopen("mach_code.txt","w");
  if (!field_id) 
    $display("rats - can't open");
  else forever begin	 :floop
    while(!$feof(field_id)) 
      #10ns if($fgets(line, field_id)) begin
        $write(line);
	for(int j=0; j<=15; j++) begin  
          char[j] = line.getc(j);
        end
        // 47: slash; 32: space; 10: line feed, 23: #
	if(char[0]!=23 || char[0]!=10) begin  :non_empty_line
      // $display("char0%h char1%h char2%h char3%s char4%s",char[0],char[1],char[2], char[3],char[4]);
      // $display(char[0],char[1],char[2],char[3]);
  
  case({char[0],char[1]})
    19535:    begin mach = LOAD; reg_1[0:1] = char[5:6]; addr[0:6] = char[8:14]; end
    21332:    begin mach = STOR; reg_1[0:1] = char[5:6]; addr[0:6] = char[8:14]; end
    19532:    begin mach = LSL; out_reg[0:1] = char[4:5]; reg_1[0:1] = char[7:8]; immediate = char[11]; end
    21068:    begin mach = LSR; out_reg[0:1] = char[4:5]; reg_1[0:1] = char[7:8]; immediate = char[11]; end
    16718:    begin mach = AND; out_reg[0:1] = char[4:5]; reg_1[0:1] = char[7:8]; mask = char[11]; end
    20306:    begin mach = OR; out_reg[0:1] = char[3:4]; reg_1[0:1] = char[6:7]; reg_2[0:1] = char[9:10]; end
    19544:    begin mach = LXOR; out_reg[0:1] = char[5:6]; reg_1[0:1] = char[8:9]; reg_2[0:1] = char[11:12]; end
    16984: 	  begin mach = BXOR;  out_reg[0:1] = char[5:6]; reg_1[0:1] = char[8:9]; reg_2[0:1] = char[11:12]; end
    16708: 	  begin mach = ADD; out_reg[0:1] = char[4:5]; reg_1[0:1] = char[7:8]; reg_2[0:1] = char[10:11]; end
    17475: 	  begin mach = DCD; out_reg[0:1] = char[4:5]; reg_1[0:1] = char[7:8]; reg_2[0:1] = char[10:11]; end
    17731:	  begin mach = ECNT; out_reg[0:1] = char[5:6]; reg_1[0:1] = char[8:9]; reg_2[0] = 33; reg_2[1] = 33; end
    21057:	  begin mach = RAND; out_reg[0:1] = char[5:6]; reg_1[0:1] = char[8:9]; reg_2[0:1] = char[11:12]; end
    16978:    begin mach = BRAN; end
    19525: 	  begin mach = LEAP; end
    default: begin mach = EMPTYLINE; rest[0] = " "; end
  endcase

  case({addr[0],addr[6]})
    21041:  // R_ADDR1
      dest = 2'b00;
    21042:  //R_ADDR2
      dest = 2'b01;
    22321:  //W_ADDR1
      dest = 2'b10;
    22322:  //W_ADDR2
      dest = 2'b11;
  endcase

  case (out_reg[0])
    79: //O reg
      if (out_reg[1] == 49) begin
        out_reg[0] = 0; //msb
        out_reg[1] = 0; //lsb
      end else begin
        out_reg[0] = 0; //msb
        out_reg[1] = 1; //lsb
      end
    76: //L reg
      if (out_reg[1] == 49) begin
        out_reg[0] = 1; //msb
        out_reg[1] = 0; //lsb
      end else begin
        out_reg[0] = 1; //msb
        out_reg[1] = 1; //lsb
      end
    endcase

    case (reg_1[0])
    79: //O reg
      if (reg_1[1] == 49) begin
        reg_1[0] = 0; //msb
        reg_1[1] = 0; //lsb
      end else begin
        reg_1[0] = 0; //msb
        reg_1[1] = 1; //lsb
      end
    76: //L reg
      if (reg_1[1] == 49) begin
        reg_1[0] = 1; //msb
        reg_1[1] = 0; //lsb
      end else begin
        reg_1[0] = 1; //msb
        reg_1[1] = 1; //lsb
      end
    endcase

    case (reg_2[0])
    79: //O reg
      if (reg_2[1] == 49) begin
        reg_2[0] = 0; //msb
        reg_2[1] = 0; //lsb
      end else begin
        reg_2[0] = 0; //msb
        reg_2[1] = 1; //lsb
      end
    76: //L reg
      if (reg_2[1] == 49) begin
        reg_2[0] = 1; //msb
        reg_2[1] = 0; //lsb
      end else begin
        reg_2[0] = 1; //msb
        reg_2[1] = 1; //lsb
      end
    endcase

    case (immediate)
    48: //0
      log_code = 3'b000;
    49: //1
      log_code = 3'b001;
    50: //2
      log_code = 3'b010;
    52: //4
      log_code = 3'b011;
    53: //5
      log_code = 3'b100;
    55: //7
      log_code = 3'b101;
    default: //default 0 incase
      log_code = 3'b000;
    endcase

    case (mask)
    49:
        log_codemask = 3'b110;
    50:
        log_codemask = 3'b111;
    endcase

    //O1 O2
    if (reg_1[0] == 0 && reg_1[1] == 0 && reg_2[0]  == 0 && reg_2[1]  == 1)
      reg_comb = 3'b000;
    else if (reg_1[0] == 0 && reg_1[1]  == 1 && reg_2[0]  == 0 && reg_2[1]  == 0)
      reg_comb = 3'b000;
    //O1 L1
    else if (reg_1[0] == 0 && reg_1[1]  == 0 && reg_2[0]  == 1 && reg_2[1]  == 0)
      reg_comb = 3'b001;
    else if (reg_1[0] == 1 && reg_1[1]  == 0 && reg_2[0]  == 0 && reg_2[1]  == 0)
      reg_comb = 3'b001;
    //O1 L2
    else if (reg_1[0] == 0 && reg_1[1]  == 0 && reg_2[0]  == 1 && reg_2[1]  == 1)
      reg_comb = 3'b010;
    else if (reg_1[0] == 1 && reg_1[1]  == 1 && reg_2[0]  == 0 && reg_2[1]  == 0)
      reg_comb = 3'b010;
    //O2 L1
    else if (reg_1[0] == 0 && reg_1[1]  == 1 && reg_2[0]  == 1 && reg_2[1]  == 0)
      reg_comb = 3'b011;
    else if (reg_1[0] == 1 && reg_1[1]  == 0 && reg_2[0]  == 0 && reg_2[1]  == 1)
      reg_comb = 3'b011;
    //O2 L2
    else if (reg_1[0] == 0 && reg_1[1]  == 1 && reg_2[0]  == 1 && reg_2[1]  == 1)
      reg_comb = 3'b100;
    else if (reg_1[0] == 1 && reg_1[1]  == 1 && reg_2[0]  == 0 && reg_2[1]  == 1)
      reg_comb = 3'b100;
    //O1
    else if (reg_1[0] == 0 && reg_1[1]  == 0 && reg_2[0]  == 33 && reg_2[1]  == 33)
      reg_comb = 3'b101;
    //O2
    else if (reg_1[0] == 0 && reg_1[1]  == 1 && reg_2[0]  == 33 && reg_2[1]  == 33)
      reg_comb = 3'b110;
    else
      reg_comb = 3'b111; //this should never happen

  case(mach)
    LOAD: begin
      machine_code[8:6] = 3'b000;
      machine_code[5] = reg_1[0];
      machine_code[4] = reg_1[1];
      machine_code[3:2] = dest;
      
    end
    STOR: begin
      machine_code[8:6] = 3'b001;
      machine_code[5] = reg_1[0];
      machine_code[4] = reg_1[1];
      machine_code[3:2] = dest;

    end
    LSL: begin
      machine_code[8:7] = 2'b01;
      machine_code[6:4] = log_code;
      machine_code[3] = 'b0;
      machine_code[2] = reg_1[0];
      machine_code[1] = reg_1[1];
      machine_code[0] = out_reg[1];
    end
    LSR: begin
      machine_code[8:7] = 2'b01;
      machine_code[6:4] = log_code;
      machine_code[3] = 'b1;
      machine_code[2] = reg_1[0];
      machine_code[1] = reg_1[1];
      machine_code[0] = out_reg[1];
    end
    AND: begin
      machine_code[8:7] = 2'b01;
      machine_code[6:4] = log_codemask;
      machine_code[3] = 'b0;
      machine_code[2] = reg_1[0];
      machine_code[1] = reg_1[1];
      machine_code[0] = out_reg[1];
    end
    OR: begin
      machine_code[8:4] = 5'b10000;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    LXOR: begin
      machine_code[8:4] = 5'b10001;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    BXOR: begin
      machine_code[8:4] = 5'b10010;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    ADD: begin
      machine_code[8:4] = 5'b10011;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    DCD: begin
      machine_code[8:4] = 5'b10100;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    ECNT: begin
      machine_code[8:4] = 5'b10101;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    RAND: begin
      machine_code[8:4] = 5'b10110;
      machine_code[3] = out_reg[1];
      machine_code[2:0] = reg_comb;

    end
    BRAN: begin
      machine_code[8:0] = 9'b110000000;
    end
    LEAP: begin
      machine_code[8:0] = 9'b111000000;
    end
  endcase

    if (mach != EMPTYLINE) begin
      $fdisplay(mach_code,"%b",machine_code); //no comments
      // $fdisplay(mach_code,"%b // %s",machine_code,mach);  //simple comments
      // $fdisplay(mach_code,"%b // %s",machine_code,line); //whole instruction
    end
    end		  :non_empty_line
    else $display("char[0]==47");
  end
    #10ns;
    $fclose(field_id);
    $fclose(mach_code);
    $fclose(mach);
    $stop;
    end		:floop
  end		    :iloop
endmodule