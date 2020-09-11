//module uart(clk,rx,tx_start,tx,par_data_tx);

//input clk,rx,tx_start;
//input [7:0] par_data_tx;
//output tx;


//receiver r1(clk,rx,rx_data,done);
//transmitter t1(clk,tx_start,par_data_tx,tx);

//clk_counter c1(clk,reset,inc_count,cnt_out);



module uart_3(clk,reset,rx_data_in,tx_start,par_data_tx,rx_data_out,tx_out,rx_done);

input clk,reset,rx_data_in,tx_start;
input [7:0] par_data_tx;
output [7:0] rx_data_out;
output tx_out,rx_done;

wire baud_clk;

//assign clk_out = baud_clk;

//receiver r1(clk,tx,rx_data,done);
//transmitter t1(clk,tx_start,par_data_tx,tx);

//pll	pll_inst ( .inclk0 ( clk ), .c0 ( baud_clk ) );
pll	pll_inst ( .inclk0 (clk), .c0 (baud_clk) );

//baud_generator b1( .rst(reset), .clk_in(clk), .clk_out(baud_clk) );

receiver r1 ( .clk(baud_clk), .rst(reset), .data_in(rx_data_in), .rx_data(rx_data_out), .done(rx_done) );

transmitter t1 ( .clk(baud_clk), .rst(reset), .tx_start(tx_start), .par_data(par_data_tx), .data_out(tx_out) );

endmodule 