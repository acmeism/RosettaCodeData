module main;
  integer i, n;

  initial begin
    n = 1000;
    i = 0;
    while (i ** 2 - (i - 1) ** 2 < n) i=i+1;
    $display(i);
    $finish ;
  end
endmodule
