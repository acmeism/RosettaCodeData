module main;
  integer n, m, num, limit, tau;

  initial begin
    $display("The first 100 tau numbers are:\n");
    n = 0;
    num = 0;
    limit = 100;

    while (num < limit) begin
      n = n + 1;
      tau = 0;
      for (m = 1; m <= n; m=m+1) if (n % m == 0) tau = tau + 1;

      if (n % tau == 0) begin
        num = num + 1;
        if (num % 5 == 1) $display("");
        $write(n);
      end
    end
    $finish ;
  end
endmodule
