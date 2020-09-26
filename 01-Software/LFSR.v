module LFSR(
input               clk           , //semnal de ceas
input               rst_n         , //reset asincorn
output reg[15:0]    data_output     //iesire lfsr

);

always @(posedge clk or negedge rst_n )
if (~ rst_n )  data_output <= 16'b0000_0000_0000_0001; else
               data_output <= {data_output[15] ^ data_output[13] ^ data_output[4] ^ data_output[0] , data_output[15:1]};

endmodule