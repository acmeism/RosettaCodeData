module main;
  integer n, num;

  initial begin
      $display("First 20 Cullen numbers:");
      for(n = 1; n <= 20; n=n+1)
      begin
        num = n * (2 ** n) + 1;
        $write(num, "  ");
      end
      $display("");
      $display("First 20 Woodall numbers:");
      for(n = 1; n <= 20; n=n+1)
      begin
        num = n * (2 ** n) - 1;
        $write(num, "  ");
      end
      $finish ;
    end
endmodule
