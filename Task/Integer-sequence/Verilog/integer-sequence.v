module main;
  integer  i;

  initial begin
    i = 1;

    while(i > 0) begin
        $display(i);
        i = i + 1;
    end
  $finish ;
  end
endmodule
