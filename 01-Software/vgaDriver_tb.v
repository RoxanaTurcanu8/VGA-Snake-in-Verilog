module vgaDriver_tb (
output reg clk , 
output reg rst_n ,
output reg enable
);


initial begin
clk = 1'b0;
forever #5 clk = ~ clk ;
end

initial begin
rst_n <= 1 'b0 ;
enable<= 1'b1;
@(posedge clk ) ;
rst_n <= 1 'b1 ;
enable <= 1'b0;
@(posedge clk ) ;
@(posedge clk ) ;
rst_n <= 1'b0 ;
enable <= 1'b1;
@(posedge clk ) ;
end
endmodule