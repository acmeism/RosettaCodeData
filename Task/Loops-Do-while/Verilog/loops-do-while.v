module main;
  integer  i;

  initial begin
    i = 1;

    $write(i);
    while(i % 6 != 0) begin
      i = i + 1;
      $write(i);
    end
  $finish ;
  end
endmodule
