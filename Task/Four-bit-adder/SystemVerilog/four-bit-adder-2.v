module simTop();

  bit [3:0] a;
  bit [3:0] b;
  bit [4:0] s;

  Multibit_Adder#(4) adder(.*);

  always_comb begin
    $display( "%d + %d = %d", a, b, s );
    assert( s == a+b );
  end

endmodule

program Main();

  class Test;
    rand bit [3:0] a;
    rand bit [3:0] b;
  endclass

  Test t = new;
  initial repeat (20) begin
    #10 t.randomize;
    simTop.a = t.a;
    simTop.b = t.b;
  end

endprogram
