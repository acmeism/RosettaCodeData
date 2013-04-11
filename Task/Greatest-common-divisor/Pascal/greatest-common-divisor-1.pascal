function gcd_recursive(u, v: longint): longint;
  begin
    if u mod v <> 0 then
        gcd_recursive := gcd_recursive(v, u mod v)
    else
        gcd_recursive := v;
  end;
