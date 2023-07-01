module rotate(in, out, shift);

  parameter BITS = 32;
  parameter SHIFT_BITS = 5;

  input  [BITS-1:0] in;
  output [BITS-1:0] out;
  input  [SHIFT_BITS-1:0] shift;

  always_comb foreach (out[i]) out[i] = in[ (i+shift) % BITS ];

endmodule
