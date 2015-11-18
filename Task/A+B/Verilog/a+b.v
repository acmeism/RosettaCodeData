module TEST;

  reg signed [11:0] y;

  initial begin
    y= sum(2, 2);
    y= sum(3, 2);
    y= sum(-3, 2);
  end

  function signed [11:0] sum;
    input signed [10:0] a, b;
    begin
      sum= a + b;
      $display("%d + %d = %d",a,b,sum);
    end
  endfunction

endmodule
