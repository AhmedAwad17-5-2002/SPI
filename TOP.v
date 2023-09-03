module TOP (MOSI,MISO,SS_n,clk,rst_n);
input  MOSI,clk,rst_n,SS_n;
output MISO;
wire [9:0]rx_data;
wire [7:0]tx_data;
wire rx_valid,tx_valid;

RAM m0 (rx_data,rx_valid,clk,rst_n,tx_data,tx_valid);
SLAVE m1(MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid); 


endmodule