module main;
  integer  number;

  initial begin

  for(number = 1; number < 100; number = number + 1) begin
    if (number % 15 == 0) $display("FizzBuzz");
    else begin
      if(number % 3 == 0) $display("Fizz");
      else begin
        if(number % 5 == 0) $display("Buzz");
        else $display(number);
      end
    end
  end
  $finish;
  end
endmodule
