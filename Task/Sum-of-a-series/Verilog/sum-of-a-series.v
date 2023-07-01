module main;
  integer i;
  real sum;

  initial begin
    sum = 0.0;
    for(i = 1; i <= 1000; i=i+1)  sum = sum + 1.0 / (i * i);
    $display(sum);
  end
endmodule
