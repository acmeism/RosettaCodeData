module main;
  integer N, T, A;

  initial begin
    $display("The tau functions for the first 100 positive integers are:\n");
    for (N = 1; N <= 100; N=N+1) begin
        if (N < 3) T = N;
        else begin
            T = 2;
            for (A = 2; A <= (N+1)/2; A=A+1) begin
                if (N % A == 0) T = T + 1;
            end
        end

        $write(T);
        if (N % 10 == 0) $display("");
    end
      $finish ;
  end
endmodule
