module main;
  integer i, n;

  initial begin
    n = 45;

    $write(n, " =>");
    for(i = 1; i <= n / 2; i = i + 1) if(n % i == 0) $write(i);
    $display(n);
    $finish ;
    end
endmodule
