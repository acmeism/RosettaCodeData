function gcd_binary(u, v: longint): longint;
  var
    t, k: longint;
  begin
    u := abs(u);
    v := abs(v);
    if u < v then
    begin
      t := u;
      u := v;
      v := t;
    end;
    if v = 0 then
      gcd_binary := u
    else
    begin
      k := 1;
      while (u mod 2 = 0) and (v mod 2 = 0) do
      begin
        u := u >> 1;
        v := v >> 1;
	k := k << 1;
      end;
      if u mod 2 = 0 then
        t := u
      else
        t := -v;
      while t <> 0 do
      begin
        while t mod 2 = 0 do
          t := t div 2;
        if t > 0 then
          u := t
        else
          v := -t;
        t := u - v;
      end;
      gcd_binary := u * k;
    end;
  end;
