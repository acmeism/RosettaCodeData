module main;
  integer  i;

  initial begin

    for(i = 1; i <= 21; i = i + 2)  $write(i);
  $finish ;
  end
endmodule
