module pancake;
  integer i, j, n;
  integer p;

  initial begin
    for (i = 0; i <= 3; i = i + 1) begin
      for (j = 1; j <= 5; j = j + 1) begin
        n = (i * 5) + j;
        p = pancake(n);
        $display("p(%0d) = %0d", n, p);
      end
    end
  end

  function integer pancake;
    input integer n;
    integer gap, sum, adj;
    begin
      gap = 2;
      sum = 2;
      adj = -1;
      while (sum < n) begin
        adj = adj + 1;
        gap = (gap * 2) - 1;
        sum = sum + gap;
      end
      pancake = n + adj;
    end
  endfunction
endmodule
