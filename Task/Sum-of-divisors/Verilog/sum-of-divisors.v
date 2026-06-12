module main;
  integer n, p, i;

  initial begin
      $write("1");
      for(n=2; n<=100; n=n+1) begin
    	p = 1 + n;
    	for(i=2; i<=n/2; i=i+1) if(n % i == 0) p = p + i;
    	$write(p);
      end
      $finish ;
    end
endmodule
