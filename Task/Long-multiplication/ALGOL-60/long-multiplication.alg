procedure multiplyBCD (m, n, u, v, w);
  comment
    Multiply array u of length m by array v of length n,
    putting the result in array w of length (m + n). the
    numbers are stored as binary coded decimal, most
    significant digit first.
  ;
  value m, n;
  integer m, n;
  integer array u, v, w;
begin
  integer i, j, carry, t;

  for j := 0 step 1 until n - 1 do
    begin
      if v[n - 1 - j] = 0 then
        begin
          comment (optional branch);
          w[n - 1 - j] := 0
        end
      else
        begin
          carry := 0;
          for i := 0 step 1 until m - 1 do
            begin
              t := (u[m - 1 - i] * v[n - 1 - j])
                      + w[m + n - 1 - i - j] + carry;
              carry := t % 10;  comment (integer division);
              w[m + n - 1 - i - j] := t - (carry * 10)
            end;
          w[n - 1 - j] := carry
        end
    end
end;

procedure printBCD (m, u);
  value m;
  integer m;
  integer array u;
begin
  integer i, j;

  comment  Skip leading zeros;
  i := 0;
  for j := i while j < m - 1 & u[j] = 0 do
    i := i + 1;

  comment  Print the digits, and separators;
  for j := i step 1 until m - 1 do
    begin
      if j != i & ((m - j) % 3) * 3 = m - j then
        begin
          comment  Print UTF-8 for a narrow no-break space (U+202F);
          outstring (1, "\xE2\x80\xAF")
        end;
      outchar (1, "0123456789", u[j] + 1)
    end
end;

begin
  integer array u[0 : 19];
  integer array v[0 : 19];
  integer array w[0 : 39];

  u[0] := 1; u[1] := 8; u[2] := 4; u[3] := 4;
  u[4] := 6; u[5] := 7; u[6] := 4; u[7] := 4;
  u[8] := 0; u[9] := 7; u[10] := 3; u[11] := 7;
  u[12] := 0; u[13] := 9; u[14] := 5; u[15] := 5;
  u[16] := 1; u[17] := 6; u[18] := 1; u[19] := 6;

  v[0] := 1; v[1] := 8; v[2] := 4; v[3] := 4;
  v[4] := 6; v[5] := 7; v[6] := 4; v[7] := 4;
  v[8] := 0; v[9] := 7; v[10] := 3; v[11] := 7;
  v[12] := 0; v[13] := 9; v[14] := 5; v[15] := 5;
  v[16] := 1; v[17] := 6; v[18] := 1; v[19] := 6;

  multiplyBCD (20, 20, u, v, w);
  outstring (1, "u = "); printBCD (20, u); outstring (1, "\n");
  outstring (1, "v = "); printBCD (20, v); outstring (1, "\n");
  outstring (1, "u × v = "); printBCD (40, w); outstring (1, "\n")
end
