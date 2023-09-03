module TB ();
reg  MOSI,clk,rst_n,SS_n;
wire MISO;
integer i;
TOP m0 (MOSI,MISO,SS_n,clk,rst_n);


initial begin
  $readmemh("DATA.dat",m0.m0.ram);

	clk=0;
	forever #1 clk=~clk;
end

initial begin
	$display("start rst_n case = ",$time);
	rst_n=0;
	repeat(5) begin
		MOSI=$random;
		SS_n=$random;
		#2;
	end
	$display("end rst_n case = ",$time);
#4;
  rst_n=1;
  SS_n=0;
  MOSI=0;


  //1
  #2 MOSI=0;
  #2 MOSI=0;
  #2 MOSI=0;
  repeat(8) begin
  #2 MOSI=$random;
end
  #30 SS_n=1;


//2
  #4 SS_n=0;
  #2 MOSI=0;
  #2 MOSI=0;
  #2 MOSI=1;
  repeat(8) begin
  #2 MOSI=$random;
  end
  #30 SS_n=1;


//3
#2 SS_n=0;
#2 MOSI=1;
#2 MOSI=1;
#2 MOSI=0;
repeat(8) begin
	#2 MOSI=$random;
end
#30 SS_n=1;

//4
#2 SS_n=0;
#2 MOSI=1;
#2 MOSI=1;
#2 MOSI=1;
repeat(8) begin
	#2 MOSI=$random;
end
#30 SS_n=1;

//3
#2 SS_n=0;
#2 MOSI=1;
#2 MOSI=1;
#2 MOSI=0;
repeat(8) begin
  #2 MOSI=$random;
end
#30 SS_n=1;

//4
#2 SS_n=0;
#2 MOSI=1;
#2 MOSI=1;
#2 MOSI=1;
repeat(8) begin
  #2 MOSI=$random;
end
#30 SS_n=1;

#4 $stop;
end
endmodule	
