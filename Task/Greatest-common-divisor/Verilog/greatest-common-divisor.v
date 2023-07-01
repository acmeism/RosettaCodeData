module gcd
  (
  input reset_l,
  input clk,

  input [31:0] initial_u,
  input [31:0] initial_v,
  input load,

  output reg [31:0] result,
  output reg busy
  );

reg [31:0] u, v;

always @(posedge clk or negedge reset_l)
  if (!reset_l)
    begin
      busy <= 0;
      u <= 0;
      v <= 0;
    end
  else
    begin

      result <= u + v; // Result (one of them will be zero)

      busy <= u && v; // We're still busy...

      // Repeatedly subtract smaller number from larger one
      if (v <= u)
        u <= u - v;
      else if (u < v)
        v <= v - u;

      if (load) // Load new problem when high
        begin
          u <= initial_u;
          v <= initial_v;
          busy <= 1;
        end

    end

endmodule
