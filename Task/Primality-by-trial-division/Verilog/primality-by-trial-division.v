module main;
integer i, k;
  initial begin
    $display("Prime numbers between 0 and 100:");
    for(i = 2; i <= 99; i=i+1) begin
      k=i;
      if(i[0] != 1'b0) begin
        if(k==3 | k==5 | k==7 | k==11 | k==13 | k==17 | k==19)                    $write(i);
        else if(k%3==0 | k%5==0 | k%7==0 | k%11==0 | k%13==0 | k%17==0 | k%19==0) $write("");
             else                                                                 $write(i);
      end
      if(i==10'b00 | i==10'b010)                                                  $write(i);
    end
    $finish;
  end
endmodule
