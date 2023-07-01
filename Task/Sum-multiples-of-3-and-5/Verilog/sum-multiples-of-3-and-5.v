module main;
  integer i, suma;

  initial begin
  suma = 0;
    for(i = 1; i <= 999; i=i+1)
    begin
        if(i % 3 == 0) suma = suma + i;
        else if(i % 5 == 0) suma = suma + i;
    end
    $display(suma);
    $finish ;
    end
endmodule
