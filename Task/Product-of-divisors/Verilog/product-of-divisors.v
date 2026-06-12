module main;
  integer p, n, i;

  initial begin
    for(n = 1; n <= 50; n=n+1)
    begin
      p = n;
      for(i = 2; i <= n/2; i=i+1) if (n % i == 0) p = p * i;
      $display(p);
    end
    $finish ;
  end
endmodule
