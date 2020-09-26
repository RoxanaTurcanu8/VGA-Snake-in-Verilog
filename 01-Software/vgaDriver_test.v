module vgaDriver_test(
input clk                , //clk 125Mz
input enable             , //enable Zybo
input reset_n            , //rst Zybo
input up_btn             ,
input down_btn           ,
input left_btn           ,
input right_btn          ,
output [4:0] red         ,
output [5:0] green       ,
output [4:0] blue        ,
output h_sync            ,
output v_sync            
);

wire clk_div                      ;  
wire[4:0] red_test                ;
wire[5:0] green_test              ;
wire[4:0] blue_test               ;
wire[9:0] row                     ;
wire[9:0] column                  ;
wire      up_btn_debounce         ;
wire      down_btn_debounce       ;
wire      left_btn_debounce       ;
wire      right_btn_debounce      ;
wire[15:0]lfsr_output             ;


vgaDriver 
i_vgaDriver (
.clk        (clk_div   ),
.rst_n      (~reset_n ),
.enable     (enable),
.h_sync      (h_sync),
.v_sync      (v_sync),
.red          (red  ),
.green        (green ),
.blue         (blue  ),
.row          (row   ),
.column       (column ),
.red_i        (red_test),
.green_i      (green_test),
.blue_i       (blue_test)

);

/*vgaDriver_tb
a_vgaDriver_tb(

.clk         (clk_div    ),
.rst_n       (reset_n  ),
.enable      (enable )
);*/

clk_divider 
i_clk_divider (
.clk_50mhz    (clk_div   ),
.clk          (clk ) 

);

snake i_snake (
.clk          (clk_div   ),
.rst_n        (~reset_n  ),
.row          (row       ),
.column       (column    ),
.red          (red_test  ),
.green        (green_test),
.blue         (blue_test ),
.up_btn       (up_btn    ),
.down_btn     (down_btn  ),
.left_btn     (left_btn  ),
.right_btn    (right_btn ),
.rnd_i        (lfsr_output)

);

debounce up_debounce (
.clk         (clk_div         ),
.rst_n       (reset_n         ),
.data_i      (up_btn          ),
.data_o      (up_btn_debounce ) 

);

debounce down_debounce (
.clk         (clk_div         ),
.rst_n       (reset_n         ),
.data_i      (down_btn         ),
.data_o      (down_btn_debounce ) 

);

debounce left_debounce (
.clk         (clk_div         ),
.rst_n       (reset_n         ),
.data_i      (left_btn        ),
.data_o      (left_btn_debounce   ) 

);

debounce right_debounce (
.clk         (clk_div         ),
.rst_n       (reset_n         ),
.data_i      (right_btn        ),
.data_o      (right_btn_debounce   ) 

);

LFSR i_LFSR (
.clk         (clk_div    ), 
.rst_n       (enable     ),
.data_output (lfsr_output)
);
endmodule