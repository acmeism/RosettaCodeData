module main;
integer a, b;

  initial begin
      a = 1; //true
      b = 0; //false
      $display(a && b);  //AND
      $display(a || b);  //OR
      $display(!a);      //NOT
      $finish ;
    end
endmodule
