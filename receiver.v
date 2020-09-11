module receiver(clk,rst,data_in,rx_data,done);

input clk,rst,data_in;
output reg [7:0] rx_data;
output reg done;

parameter idle=2'b00,start_check=2'b01,sample_data=2'b10,load=2'b11;

reg [1:0] state;
reg glitch_flag,inc_count,start_sample,clr_count,clr_flag,x;
reg [3:0] clk_count,bit_count;
reg [8:0] temp_rx;

always @(posedge clk)
	begin
	
		//data = data_in;
		if(!rst)										// Since push button gives logic 0 when pressed
		state<= idle;

		else
		begin
			case(state)

			idle: 
				if(!data_in)
				state<=start_check;

			start_check:
			begin
				if(clk_count==7)
				state<=sample_data;
				else if(glitch_flag)
				state<=idle;
			end

			sample_data:
				if(bit_count==9)
				state<=load;

			load:
				state<=idle;
			
			default:
				state<=idle;

			endcase

		end

end


always @(*)
begin

	case (state)

	idle:
	begin
		inc_count<=0;
		clr_count<=1;
		clr_flag<=0;
		start_sample<=0;
		done<=0;
		rx_data<=8'hzz;
			
	end

	start_check:
	begin
		clr_count<=0;
		clr_flag<=0;
		start_sample<=0;
		done<=0;
		rx_data<=8'hzz;
		inc_count<=1;
	end

	sample_data:
	begin
		clr_count<=0;
		inc_count<=0;
		done<=0;
		rx_data<=8'hzz;
		clr_flag<=1;
		start_sample<=1;

	end

	load:
	begin
		clr_count<=0;
	   inc_count<=0;
		clr_flag<=0;
		start_sample<=0;
		if(temp_rx[8])
		begin
			rx_data<=temp_rx[7:0];
			done<=1;
		end

		else
		   done<=0;
			// Here we need to add a signal which will request for retransmission of the 8 bit block  
	end
	
	default:
	begin
		inc_count<=0;
		clr_count<=0;
		clr_flag<=0;
		start_sample<=0;
		done<=0;
		rx_data<=8'hzz;
	
	end

	endcase

end


always @(posedge clk)
begin
 
	if(clr_count || rst)
	begin
		clk_count<=3'b000;
		glitch_flag<=0; 
		bit_count<=4'h0;
		x<=0;
	end 
 
	else if(inc_count)
	begin
		if(!data_in)
		clk_count<=clk_count + 4'b0001;

		else if(data_in)
		begin
			glitch_flag<=1;

		end

	end

	else if(start_sample)
	begin

		if(clr_flag && !x)
		begin
			clk_count<=4'b0000;
			x<=1;

		end


		else if((clk_count==14) && (bit_count<=8))
		begin

			temp_rx[bit_count]<=data_in;
			bit_count<=bit_count + 4'b0001;
			//clk_count<=4'b0000;
			x<=0;
			
		end

		else clk_count<=clk_count + 4'b0001;

	end

end

endmodule 
























