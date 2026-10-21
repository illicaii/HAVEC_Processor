// program counter
module MC #(parameter D=12)(
  input reset,					        // synchronous reset
        clk,
        leap_en,
  input [1:0] sel,
  output logic[D-1:0] mem_addr		      
);

  logic[D-1:0] data_inA;
  logic[D-1:0] data_inB;
  logic[D-1:0] data_outA;
  logic[D-1:0] data_outB;

  //combinational mem_addr read
  always_comb begin 
        case(sel)
        2'b00:
          mem_addr = data_inA;
        2'b01:
          mem_addr = data_inB;
        2'b10:
          mem_addr = data_outA;
        2'b11:
          mem_addr = data_outB;
      endcase
  end

  always_ff @(posedge clk)
    if(reset) begin
	    data_inA <= 0; //LSB
      data_inB <= 1; //MSB
      data_outA <= 30; //LSB out
      data_outB <= 31; //MSB out
    end
    else if(leap_en) begin
      data_inA <= data_inA + 2; //LSB
      data_inB <= data_inB + 2; //MSB
      data_outA <= data_outA + 2; //LSB out
      data_outB <= data_outB + 2; //MSB out
    end
      

endmodule