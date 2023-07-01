module main;
  integer i;
  real suma, num;

  initial begin
    $display("10 primeros términos de la sucesión de sylvester:");
    $display("");

    suma = 0;
    num = 0;
    for(i=1; i<=10; i=i+1) begin
        if (i==1) num = 2;
        else      num = num * num - num + 1;

        $display(i, ": ", num);
        suma = suma + 1 / num;
    end

    $display("");
    $display("suma de sus recíprocos: ", suma);
    $finish ;
  end
endmodule
