module tb_PC;

// Inputs
  bit branch_en,
      clk,
      reset,
      leap_en;

  bit[1:0] sel;

// Outputs
  wire done;

  wire[11:0] target, 			    // Leap target
              prog_ctr;
  wire[7:0]mem_addr;

// Instantiate the Unit Under Test (UUT)
// fetch subassembly
  PC #(.D(12)) 					  // D sets program counter width
     pc1 (.reset            ,
          .clk              ,
		      .leap_en          ,
		      .target           ,
		      .prog_ctr          );

// facilitate leaps/branches
  brancher #(.D(12))
    br1 (.reset            ,
         .branch_en,
         .clk,
         .prog_ctr,
         .target          );  

  done_counter #(.D(15))
  cnt1 (.leap_en,
        .clk,
        .reset,
        .done          ); 

  MC #(.D(8)) 					
    mc1 (.reset           ,
        .clk              ,
        .leap_en          ,
        .sel              ,
        .mem_addr          ); 
 

initial begin
// Wait 100 ns for global reset to finish
  #100ns;
  reset = 1;
  sel = 0;
  #50ns  reset = 0;     

// Add stimulus here
  branch_en = 1;
  #10ns  branch_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #100ns leap_en = 1;
  #10ns leap_en = 0;

  #10ns $stop;

end

always begin
  #5ns clk = 0;        // tic
  #5ns clk = 1;			   // toc
end		

endmodule

