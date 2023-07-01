module main;
  integer i;

  initial begin
    for(i = 97; i <= 122; i=i+1)
    begin
      $write("%c ",i);
    end
      $finish ;
    end
endmodule
