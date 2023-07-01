module main;
  integer n, i;
  real h;

  initial begin
    h = 0.0;

    $display("The first twenty harmonic numbers are:");
    for(n=1; n<=20; n=n+1) begin
      h = h + 1.0 / n;
      $display(n, "  ", h);
    end
    $display("");

    h = 1.0;
    n = 2;
    for(i=2; i<=10; i=i+1) begin
      while (h < i) begin
        h = h + 1.0 / n;
        n = n + 1;
      end
      $write("The first harmonic number greater than ");
      $display(i, " is ", h, ", at position ", n-1);
    end
    $finish ;
  end
endmodule
