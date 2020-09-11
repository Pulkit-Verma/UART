module transmitter(clk,rst,tx_start,par_data,data_out);

input clk,rst,tx_start;
input [7:0] par_data;
output reg data_out;

parameter idle=1'b0,load_and_send=1'b1;

reg state;
reg [7:0] tx_buf;
reg [3:0] count;
reg clr_count,begin_tx,tx_done;
integer bit_count;

always @(posedge clk)
begin
	if(!rst)								// Since push button gives logic 0 when pressed
	state<=idle;

	else
	begin

		case(state)

		idle:
			if(!tx_start)				// Since push button gives logic 0 when pressed
			state<=load_and_send; 

		load_and_send:
			begin
			
			if(bit_count == 10)
			begin
				state<=idle;
				tx_done<=1;
			
			end
			
			end
		
		default:
		state<=idle;

		endcase

	end

end


always @(*)
begin

	case(state)

	idle:
		begin
		clr_count<=1;
		begin_tx<=0;
		tx_buf<=8'hff;

		end

	load_and_send:
		begin
		tx_buf<=par_data;
		clr_count<=0;
		begin_tx<=1;

		end
	
	default:
		begin
		clr_count<=1;
		begin_tx<=0;
		tx_buf<=8'hff;
		
		end

	endcase

end


always @(posedge clk)
begin
	if(rst)
	count<=4'b0000;
	
	else
	begin

		if(clr_count)
		begin
			count<=4'b0000;
			data_out<=1;
			bit_count<=0;

		end

		else if(begin_tx && (bit_count<=9))
		begin

			if(bit_count == 0)
				data_out<=0;
			else if(bit_count == 9)
				data_out<=1;
			else
				data_out<=tx_buf[bit_count-1];

			if(count==15)
			begin
				bit_count<=bit_count + 4'b0001;
				count<=4'b0000;
			end

			else 
				count<=count + 4'b0001;

		end

	end

end

endmodule 