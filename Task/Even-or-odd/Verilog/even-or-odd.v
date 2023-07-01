module main;
  integer i;

  initial begin
        for (i = 1; i <= 10; i = i+1) begin
          if (i % 2 == 0) $display(i, " is even");
          else            $display(i, " is odd");
        end
      $finish ;
    end
endmodule
