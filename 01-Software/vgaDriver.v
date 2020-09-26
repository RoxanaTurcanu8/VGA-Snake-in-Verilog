module vgaDriver(
input            clk        , 
input            rst_n      , //reset asincron, activ low
input            enable     , //semnal de enable
input      [4:0] blue_i     , //semnal blue din modulul snake
input      [4:0] red_i      , //semnal red din modulul snake
input      [5:0] green_i    , //semnal green din modulul snake
output reg [4:0] red        , //semnal de iesire din vgaDriver
output reg [5:0] green      , 
output reg [4:0] blue       ,
output reg [9:0] row        , //semnale care indica randul curent
output reg [9:0] column     , //semnale care indica coloana curent
output reg       h_sync     , //semnal output vgaDriver
output reg       v_sync


);


reg[10:0] h_sync_cnt;   //numara tactele/pixelii
reg[9:0]  v_sync_cnt;  //numara frame-uri

always @(posedge clk or negedge rst_n)     //controlez row
if(~rst_n)              row = 10'b0; else
if(v_sync_cnt > 600)    row = 600; else     //row mentinut in visible area
                        row = v_sync_cnt;   //row ia valorile v_sync_cnt in visible area
						
always @(posedge clk or negedge rst_n)
if(~rst_n)              column = 10'b0; else
if(h_sync_cnt > 800)    column = 800; else     //in afara visible area
                        column = h_sync_cnt;   //column ia valorile h_sync_cnt in visible area
						
always @(posedge clk or negedge rst_n)
if  (~rst_n )            h_sync_cnt = 11'b0; else
if( h_sync_cnt == 1039 ) h_sync_cnt = 'b0; else    //s-a numarat o linie
	                     h_sync_cnt = h_sync_cnt+1; 
						 
always @(posedge clk or negedge rst_n)
if (~rst_n )             v_sync_cnt = 10'b0; else
if( v_sync_cnt == 665 & h_sync_cnt == 1039)  v_sync_cnt = 'b0; else //resetez final de frame & final de linie
if( h_sync_cnt == 1039 ) v_sync_cnt = v_sync_cnt+1;                 //cand am numarat o linie (h_sync_cnt) se poate incrementa vsync
						 
always @(posedge clk or negedge rst_n)
if (~rst_n ) h_sync = 'b0; else
if(h_sync_cnt >= 0 && h_sync_cnt <800) begin //ma aflu in visible area
		h_sync=1; end
	else if(h_sync_cnt >= 800 && h_sync_cnt < 856) begin //front porch-ul semnalului hsync
		h_sync = 'b1; end
	else if(h_sync_cnt >= 856 && h_sync_cnt<976) begin //h_sync pulse
		h_sync = 'b0; end
	else if(h_sync_cnt >= 976 && h_sync_cnt <1040) //back porch-ul semnalului h_sync
		begin 
		h_sync ='b1;
		end

always @(posedge clk or negedge rst_n)
if (~rst_n ) v_sync = 'b0; else
if(v_sync_cnt >=0 && v_sync_cnt<600) //ma aflu in visible frame area
		v_sync = 'b1;
	else if(v_sync_cnt >= 600 && v_sync_cnt < 637) //front porch-ul lui vsync
		v_sync = 'b1; 
	else if (v_sync_cnt >= 637 && v_sync_cnt < 643) //v_sync pulse
		v_sync = 'b0; 	
	else if(v_sync_cnt >= 643 && v_sync_cnt < 666) //back porch-ul semnalului vsync
		v_sync = 'b1;


always @(posedge clk or negedge rst_n) 
if (~rst_n ) red = 'b0; else
if(((h_sync_cnt >= 0) && (h_sync_cnt <800))&&((v_sync_cnt >=0) && (v_sync_cnt<600)) && (enable)) //ma aflu in visible area
		red = red_i;        //trimiterea catre monitor a valorii primite de la modulul snake
	else if(((h_sync_cnt >= 800) && (h_sync_cnt < 1040))||((v_sync_cnt >= 600) && (v_sync_cnt < 666))) 
		red = 'b0;


always @(posedge clk or negedge rst_n)begin
if (~rst_n ) green = 'b0; else
if(((h_sync_cnt >= 0) &&( h_sync_cnt <800))&&((v_sync_cnt >=0) &&(v_sync_cnt<600))&&(enable)) //ma aflu in visible area
		 green = green_i;   //trimiterea catre monitor a valorii primite de la modulul snake
	else if(((h_sync_cnt >= 800) && (h_sync_cnt < 1040))||((v_sync_cnt >= 600) && (v_sync_cnt < 666))) 
		 green = 'b0;end

always @(posedge clk or negedge rst_n)begin
if (~rst_n ) blue = 'b0;	else
if(((h_sync_cnt >= 0) &&( h_sync_cnt <800))&&((v_sync_cnt >=0 )&& (v_sync_cnt<600))&&(enable)) //ma aflu in visible area
		 blue = blue_i;    //trimiterea catre monitor a valorii primite de la modulul snake
else if(((h_sync_cnt >= 800) && (h_sync_cnt < 1040))||((v_sync_cnt >= 600) && (v_sync_cnt < 666))) 
		 blue = 'b0;end 
		 


endmodule