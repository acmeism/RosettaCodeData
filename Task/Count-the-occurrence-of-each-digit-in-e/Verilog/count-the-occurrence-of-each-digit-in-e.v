module main;
  parameter MaxIDx = 2000;

  reg [31:0] v [0:MaxIDx-1];
  reg [31:0] dcount [0:9];
  integer i, c, a, col;
  integer outfile;

  initial begin
    for(i = 0; i <= 9; i = i + 1) begin
      dcount[i] = 0;
    end
    dcount[2] = 1;

    for(i = 0; i < MaxIDx; i = i + 1) begin
      v[i] = 1;
    end

    for(col = 0; col <= 2 * MaxIDx; col = col + 1) begin
      a = MaxIDx + 1;
      c = 0;

      for(i = 0; i < MaxIDx; i = i + 1) begin
        c = c + v[i] * 10;
        v[i] = c % a;
        c = c / a;
        a = a - 1;
      end

      dcount[c] = dcount[c] + 1;
    end

    outfile = $fopen("digits_result.txt", "w");
    for(i = 0; i <= 9; i = i + 1) begin
      $fwrite(outfile, "%0d ", dcount[i]);
      $display("%0d ", dcount[i]);
    end
    $fclose(outfile);
    $finish;
  end
endmodule
