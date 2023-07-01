module Half_Adder( input a, b, output s, c );
  assign s = a ^ b;
  assign c = a & b;
endmodule

module Full_Adder( input a, b, c_in, output s, c_out );

  wire s_ha1, c_ha1, c_ha2;

  Half_Adder ha1( .a(c_in), .b(a), .s(s_ha1), .c(c_ha1) );
  Half_Adder ha2( .a(s_ha1), .b(b), .s(s), .c(c_ha2) );
  assign c_out = c_ha1 | c_ha2;

endmodule


module Multibit_Adder(a,b,s);
  parameter N = 8;
  input [N-1:0] a;
  input [N-1:0] b;
  output [N:0] s;

  wire [N:0] c;

  assign c[0] = 0;
  assign s[N] = c[N];

  generate
    genvar I;
    for (I=0; I<N; ++I) Full_Adder add( .a(a[I]), .b(b[I]), .s(s[I]), .c_in(c[I]), .c_out(c[I+1]) );
  endgenerate

endmodule
