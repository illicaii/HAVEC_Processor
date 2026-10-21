// cache memory/register file
// default address pointer width = 2, for 4 registers (L1, L2, O1, O2)
module reg_file #(parameter pw=2)(
  input[7:0] dat_in,
  input      clk,
  input      reset,
  input      wr_en,           // write enable
  input[1:0] wr_addr,		      // write address pointer
  input[1:0] rd_addrA,		    // read address pointers
	input[1:0] rd_addrB,
  output logic[7:0] datA_out, // read data
                    datB_out);

  bit[7:0] core[2**pw];    // 2-dim array  8 wide  4 deep

// reads are combinational
  assign datA_out = core[rd_addrA];
  assign datB_out = core[rd_addrB];

// writes are sequential (clocked)
  always_ff @(posedge clk) begin
    if (reset) begin
      core[2'b00] <= '0;
      core[2'b01] <= '0;
      core[2'b10] <= '0;
      core[2'b11] <= '0;
    end else if(wr_en)				   // anything but stores or no ops
      core[wr_addr] <= dat_in;
  end
endmodule
