module done_counter #(parameter D=15)(
  input			leap_en,
  input     clk,
  input     reset,
  output logic done);

  logic[8:0] ctr;

  always_ff @(posedge clk)
  if(reset) begin
    ctr <= '0;
    done <= '0;
  end
  else if(leap_en) begin
    ctr <= ctr+ 'b1;
    if (ctr == D-1) begin
      done <= 'b1;
      ctr <= 'b0;
    end
    else
      done <= 'b0;
  end
endmodule
