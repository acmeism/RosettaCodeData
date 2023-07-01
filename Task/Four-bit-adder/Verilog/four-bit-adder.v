module Half_Adder( output c, s, input a, b );
  xor xor01 (s, a, b);
  and and01 (c, a, b);
endmodule // Half_Adder

module Full_Adder( output c_out, s, input a, b, c_in );

  wire s_ha1, c_ha1, c_ha2;

  Half_Adder ha01( c_ha1, s_ha1, a, b );
  Half_Adder ha02( c_ha2, s, s_ha1, c_in );
  or or01 ( c_out, c_ha1, c_ha2 );

endmodule // Full_Adder

module Full_Adder4( output [4:0] s, input [3:0] a, b, input c_in );

  wire [4:0] c;

  Full_Adder adder00 ( c[1], s[0], a[0], b[0], c_in );
  Full_Adder adder01 ( c[2], s[1], a[1], b[1], c[1] );
  Full_Adder adder02 ( c[3], s[2], a[2], b[2], c[2] );
  Full_Adder adder03 ( c[4], s[3], a[3], b[3], c[3] );

  assign s[4] = c[4];

endmodule // Full_Adder4

module test_Full_Adder();

  reg  [3:0] a;
  reg  [3:0] b;
  wire [4:0] s;

  Full_Adder4 FA4 ( s, a, b, 0 );

  initial begin
    $display( "   a +    b =     s" );
    $monitor( "%4d + %4d = %5d", a, b, s );
     a=4'b0000; b=4'b0000;
  #1 a=4'b0000; b=4'b0001;
  #1 a=4'b0001; b=4'b0001;
  #1 a=4'b0011; b=4'b0001;
  #1 a=4'b0111; b=4'b0001;
  #1 a=4'b1111; b=4'b0001;
  end

endmodule // test_Full_Adder
