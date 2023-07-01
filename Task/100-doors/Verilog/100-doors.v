module main;
  integer i;

  initial begin
    $display("Las siguientes puertas están abiertas:");
    for (i=1; i<=10; i=i+1) if (i%i*i<11) $display(i*i);
    $finish ;
  end
endmodule
