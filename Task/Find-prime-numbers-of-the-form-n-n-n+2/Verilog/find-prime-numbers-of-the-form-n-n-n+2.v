module main;

  function integer isPrime;
    input integer ValorEval;
    integer i;
    integer prime;
    begin
      prime = 1; // We assume it is prime - Asumimos que es primo
      if (ValorEval % 2 == 0) prime = 0;
      else begin
        i = 3;
        while (i <= $sqrt(ValorEval) + 1) begin
          if (ValorEval % i == 0) prime = 0;
          i = i + 2;
        end
      end
      isPrime = prime;
    end
  endfunction

  integer n;
  initial begin
    for (n = 1; n <= 200; n = n + 1) begin
      if (isPrime(n * n * n + 2)) $display("%d\t%d", n, n * n * n + 2);
    end
  end

endmodule
