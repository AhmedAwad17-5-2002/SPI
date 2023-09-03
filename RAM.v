module RAM(din,rx_valid,clk,rst_n,dout,tx_valid);

input [9:0] din;
input rx_valid,clk,rst_n;
output reg [7:0] dout;
output reg tx_valid;
reg [7:0] MEM [255:0];
reg [7:0] write_addr,read_addr;
wire [7:0]in;
reg  Counter_read=0,Counter_write=0;

always @(posedge clk ) begin
	if (!rst_n) begin
		dout <= 0;
		tx_valid <= 0;
		Counter_write <=0;
		Counter_read <=0;
	end
	else if (din[9:8] == 2'b00 && rx_valid == 1 && Counter_write==0 && Counter_read==0) begin
		write_addr <= din[7:0];
		tx_valid <= 0;
		Counter_write <=1;
	end
	else if (din[9:8] == 2'b01 && rx_valid == 1 && Counter_write==1 && Counter_read==0) begin
		MEM[write_addr] <= din[7:0];
		tx_valid <= 0;
		Counter_write <=0;
	end
	else if (din[9:8] == 2'b10 && rx_valid == 1 && Counter_write==0 && Counter_read==0) begin
		read_addr <= din[7:0];
		tx_valid <= 0;
		Counter_read <=1;
	end
	else if (din[9:8] == 2'b11 && rx_valid == 1 && Counter_write==0 && Counter_read==1) begin
		dout <= MEM[read_addr];
		tx_valid <= 1;
		Counter_read <=0;
	end
end
endmodule