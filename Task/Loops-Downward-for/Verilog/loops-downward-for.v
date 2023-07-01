module main;
  integer  i;

  initial begin

    for(i = 10; i >= 0; i = i - 1)  $write(i);
  $finish ;
  end
endmodule
