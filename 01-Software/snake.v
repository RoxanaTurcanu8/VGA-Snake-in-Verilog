module snake(
input            clk                ,
input            rst_n              ,
input            up_btn             , //zybo up button
input            down_btn           ,
input            left_btn           ,
input            right_btn          ,
input [15:0]     rnd_i              , //data_output din LFSR
input [9:0]      row                , //output din vgaDriver     
input [9:0]      column             , //output din vgaDriver
output reg [4:0] red                , //semnal de culoare care va intra in vgaDriver
output reg [5:0] green              ,
output reg [4:0] blue

);
parameter IDLE       = 3'b000; 
parameter goingDOWN  = 3'b001; //directia butonului
parameter goingLEFT  = 3'b010;
parameter goingRIGHT = 3'b011;
parameter goingUP    = 3'b100;

reg [2:0] state; //registru care tine directia de deplasare a sarpelui

reg [9:0] x;     //coordonata x a cercului de desenat (pe coloana)
reg [9:0] y;     //coordonata y a cercului de desenat (pe rand)

reg [3:0] move_cnt; //counter folosit pt deplasarea sarpelui

reg [9:0] snake_x [0:4]; //array care contine coordoanatele lui x
reg [9:0] snake_y [0:4]; //array care contine coordoanatele lui y

reg [9:0] food_x;  //registru in care se va stoca coordonata x a mancarii
reg [9:0] food_y;  //registru in care se va stoca coordonata y a mancarii


always @(posedge clk or negedge rst_n)
if (~rst_n ) begin snake_x[0] = 355;   snake_y[0] = 299;
                   snake_x[1] = 377;   snake_y[1] = 299;
				   snake_x[2] = 399;   snake_y[2] = 299;
				   snake_x[3] = 421;   snake_y[3] = 299;
				   snake_x[4] = 443;   snake_y[4] = 299; //capul sarpelui
              end
else if (move_cnt == 10)  //se misca sarpele din 10 in 10 frame-uri
begin
	snake_x[0] = snake_x[1];
	snake_x[1] = snake_x[2];
	snake_x[2] = snake_x[3];
	snake_x[3] = snake_x[4];
	snake_y[0] = snake_y[1];
	snake_y[1] = snake_y[2];
	snake_y[2] = snake_y[3];
	snake_y[3] = snake_y[4];
case (state) 
	goingDOWN  :begin
	                if(snake_y[4] >= 600) snake_y[4] = 0; else  //cand snake_y[4] este >= 600 , se va reseta la 0
						     snake_y[4] = snake_y[4] + 22; 
				end
	goingLEFT  : begin
	                if(snake_x[4] > 800)  snake_x[4] = 800; else
							snake_x[4] = snake_x[4] - 22; 
				end
	goingRIGHT : begin

	                if(snake_x[4] >= 800) snake_x[4] = 0; else
					         snake_x[4] = snake_x[4] + 22; 
				end
	goingUP    : begin
	                if(snake_y[4] > 600)  snake_y[4] = 600; else  
					         snake_y[4] = snake_y[4] - 22; 
				end 
	IDLE :  begin  snake_x[0] = 355;   snake_y[0] = 299;
                   snake_x[1] = 377;   snake_y[1] = 299;
				   snake_x[2] = 399;   snake_y[2] = 299;
				   snake_x[3] = 421;   snake_y[3] = 299;
				   snake_x[4] = 443;   snake_y[4] = 299; //capul sarpelui
              end
endcase end

always @(posedge down_btn or posedge up_btn or posedge left_btn or posedge right_btn or negedge rst_n) //setarea starii in functie de butonul apasat
if (~rst_n )   state = IDLE;       else
if (down_btn)  state = goingDOWN;  else 
if (left_btn)  state = goingLEFT;  else
if (right_btn) state = goingRIGHT; else
if (up_btn)    state = goingUP;

always @(posedge clk or negedge rst_n)
if(~rst_n)                       move_cnt <= 'b0; else
if(move_cnt == 10)               move_cnt <= 0;   else         //dupa ce am numarat 10 frame-uri o va lua de la capat  
if((row == 0) && (column == 0))  move_cnt <= move_cnt + 1;    //se incrementeaza la fiecare inceput de frame


always @(posedge clk or negedge rst_n)                  //trimiterea catre vgaDriver a culorii de afisat
if (~rst_n ) begin  red = 'b0; green = 'b0; blue = 'b0; 
					food_x = 100; food_y = 100;        //setez coordonatele primului patrat de mancare
			end else 
begin 

if(((column-snake_x[0])*(column-snake_x[0])) + ((row-snake_y[0] )*(row-snake_y[0])) <= (15*15)) 
            begin
               red   = 'b11111;
			   green = 'b111111;
			   blue  = 'b11111;
			end  else
if(((column-snake_x[1])*(column-snake_x[1])) + ((row-snake_y[1] )*(row-snake_y[1])) <= (15*15))
             begin
			 blue  = 'b00000;
			 green = 'b111111;
			 red   = 'b11111;
			 end else
if(((column-snake_x[2])*(column-snake_x[2])) + ((row-snake_y[2] )*(row-snake_y[2])) <= (15*15))
             begin
               red   = 'b11111;
			   green = 'b000000;
			   blue  = 'b00000;
			   end else
if(((column-snake_x[3])*(column-snake_x[3])) + ((row-snake_y[3] )*(row-snake_y[3])) <= (15*15))
             begin
               blue  = 'b11111;
			   green = 'b000000;
			   red   = 'b00000;
			   end else			   
if(((column-snake_x[4])*(column-snake_x[4])) + ((row-snake_y[4] )*(row-snake_y[4])) <= (15*15)) //verific daca row si column fac parte din cerc
      begin
	    if((( column > food_x - 12 )&& (column < food_x + 12)) && ( (row > food_y - 12 )&& (row < food_y + 12))) //verific daca punctul curent face parte din patrat
			  begin
  			  food_x = rnd_i[8:0]  + 144;   //daca pct. curent face parte din patrat si cerc se vor schimba coordonatele
			  food_y = rnd_i[15:7] + 44; end
		else begin                         //culoarea capului      
			  green   = 'b000000;        
			  blue    = 'b11111;
			  red     = 'b11111;
		end
	  end
	  else
 
if((( column > food_x - 12 )&& (column < food_x + 12)) && ( (row > food_y - 12 )&& (row < food_y + 12)))
  begin
   green   = 'b000000;        //setez culorile mancarii
   blue    = 'b00000;
   red     = 'b00000; 
   end	
else begin                    //culorile fundalului
    red   = 'b00000; 
    green = 'b111111;
    blue  = 'b11111;
	end

end
			   
endmodule