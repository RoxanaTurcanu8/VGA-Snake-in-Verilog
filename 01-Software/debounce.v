/******************************************************************************
*     Project:  Debounce
*      Author:  Dan NICULA (DN)
*       Email:  dan.nicula@unitbv.ro
*   File name:  debounce.v
* Description:  Debounced input
* Date			Author		Notes
* Sep 6, 2006		DN		initial version
******************************************************************************/

module debounce #(
parameter INIT_VALUE       = 1'b0      ,
parameter DEBOUNCE_DELAY   = 16'd10000 
)(
input		  clk     ,	// clock input
input		  rst_n   , // reset active low
input		  data_i  ,	// data input
output reg		data_o   	// data output
);

//               debounce
//              +----------+
//              |          |
// data_i    -->|          |--> data_o
//              |          |
//   clk     -->|          |
//   rst_n   -->|          |
//              +----------+

reg		      datainR         ;
reg[39:0]	  debounceCounter ;
//reg		      data_o          ;
reg		      dataEdge        ;

always @(posedge clk or posedge rst_n)
if (rst_n)	datainR <= INIT_VALUE; else
            datainR <= data_i;

always @(posedge clk or posedge rst_n)
if (rst_n)	dataEdge <= 1'b0; else
            dataEdge <= datainR ^ data_i;

always @(posedge clk or posedge rst_n)
if (rst_n)			        debounceCounter <= DEBOUNCE_DELAY; else
if (dataEdge)			      debounceCounter <= DEBOUNCE_DELAY; else
if (|debounceCounter)	  debounceCounter <= debounceCounter - 1;

always @(posedge clk or posedge rst_n)
if (rst_n)			              data_o <= INIT_VALUE; else
if (debounceCounter == 16'd1)	data_o <= data_i;

endmodule // debounce