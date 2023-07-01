module main;
  real n, n1;
  real e1, e;

  initial begin
      n = 1.0;
      n1 = 1.0;
      e1 = 0.0;
      e = 1.0;

      while (e != e1) begin
        e1 = e;
        e = e + (1.0 / n);
        n1 = n1 + 1;
        n = n * n1;
      end
      $display("The value of e = ", e);
      $finish ;
    end
endmodule
