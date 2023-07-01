module main;
  integer i;

  initial begin
      i = 1024;

      while( i > 0) begin
        $display(i);
        i = i / 2;
      end
      $finish ;
    end
endmodule
