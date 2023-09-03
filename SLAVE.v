module SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b111;
(* fsm_encoding = "one_hot" *)

input  MOSI,SS_n,tx_valid,clk,rst_n;
input  [7:0] tx_data;
output reg [9:0] rx_data;
output reg MISO,rx_valid;

reg [2:0] cs,ns;
reg DONE_ADDR=0;
reg [3:0]i;
reg [2:0]j;

//**************************************************************************
/*
always@(SS_n , MOSI , cs) begin
	case({SS_n,MOSI,cs})
       5'b00000 : ns=CHK_CMD;
       5'b01000 : ns=CHK_CMD;
       5'b00001 : ns=WRITE;
       5'b10001 : ns=IDLE;
       5'b11001 : ns=IDLE;
       5'b10010 : ns=IDLE;
       5'b11010 : ns=IDLE;
       5'b01001 : if(DONE_ADDR==0)
                   ns=READ_ADD;
                  else 
                   ns=READ_DATA;
       5'b10011 : ns=IDLE;
       5'b11011 : ns=IDLE;
       5'b10100 : ns=IDLE;
       5'b11100 : ns=IDLE;
       default : ns=cs;           
	endcase
end
*/

always @(cs,MOSI,SS_n,tx_valid) begin
	case(cs)
	IDLE: begin
		if(SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = CHK_CMD;
		end
	end
	CHK_CMD: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else if (SS_n == 0 && MOSI == 0) begin
			ns = WRITE;
		end
		else if (SS_n == 0 && MOSI == 1) begin
			if (DONE_ADDR == 0) begin
				ns = READ_ADD;
			end
			else begin
				ns = READ_DATA;
			end
		end
	end
	WRITE: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = WRITE;
		end
	end
	READ_ADD: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = READ_ADD;
		end
	end
	READ_DATA: begin
		if (SS_n == 1) begin
			ns = IDLE;
		end
		else begin
			ns = READ_DATA;
		end
	end
	endcase
end

//**************************************************************************

always@(posedge clk) begin

    if (cs==IDLE) begin
    	   i <=4'b0;
    	   j <=4'b0;
	       rx_valid <=0;
	       MISO <= 0;
    	if(rst_n==0) begin
    		MISO<=0;
        DONE_ADDR<=0;
    	end
    end

	else if(cs==WRITE) begin 
	  	 if(i==10)
        rx_valid<=1;

       else begin
	      rx_data[9-i] <= MOSI;
	      i<=i+1;
	    end


	end

	else if(cs==READ_ADD) begin
		  	 if(i==10) begin
            rx_valid<=1;
          end

          else begin
	          rx_data[9-i] <= MOSI;
	          i<=i+1;
	         end

	        DONE_ADDR<=1;
    end

    else if(cs==READ_DATA) begin
    	   if(i==10) 
            rx_valid<=1;

          else if(i<10) begin
	          rx_data[9-i] <= MOSI;
	          i<=i+1;
	        end

        if(tx_valid==1 && j<8) begin
	       MISO <= tx_data[7-j];
	       j<=j+1;
	       end
           DONE_ADDR<=0; 

end
end
//***************************************************************************

always@(posedge clk)begin
	if(~rst_n)
		cs<=IDLE;
	else
		cs<=ns;
end

endmodule