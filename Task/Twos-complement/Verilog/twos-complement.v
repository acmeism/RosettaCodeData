module main;
  integer d;
  integer b[0:8];
  integer i;

  initial begin
    d = 1234567;
    b[0] = -d;
    b[1] = -d + 1;
    b[2] = -2;
    b[3] = -1;
    b[4] = 0;
    b[5] = 1;
    b[6] = 2;
    b[7] = d - 2;
    b[8] = d - 1;

    for (i = 0; i <= 8; i = i + 1) begin
      $display("%0d -> %0d", b[i], -b[i]);
    end
  end
endmodule
