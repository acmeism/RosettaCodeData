module main;
  integer  i;

  initial begin
    for(i = 1; i <= 10; i = i + 1)  begin
        $write(i);
        if (i < 10 ) $write(", ");
    end
  $display("");
  $finish ;
  end
endmodule
