module brancher #(parameter D=12)(
  input		reset,
			clk,
  			branch_en,
  input  logic[D-1:0] prog_ctr,
  output logic[D-1:0] target);

  always_ff @(posedge clk)
	if(reset)
	  target <= '0;
    else if(branch_en)				   // anything but stores or no ops
      target <= prog_ctr; 

endmodule
