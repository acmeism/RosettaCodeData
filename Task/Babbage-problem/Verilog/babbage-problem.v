module main;
  real n;

  initial begin
    while (((n**2) % 1000000) != 269696) n=n+2;
    $display("The smallest number whose square ends in 269696 is ", n);
    $display("It's square is ", n*n);
  end
endmodule
