begin
  real procedure A (integer value k; real procedure x1, x2, x3, x4, x5);
  begin
    real procedure B;
    begin k:= k - 1;
          A (k, B, x1, x2, x3, x4)
    end;
    if k <= 0 then x4 + x5 else B
  end;
  write (r_format := "A", r_w := 8, r_d := 2, A (10, 1, -1, -1, 1, 0))
end.
