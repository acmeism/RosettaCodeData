program brazilnums(output);
(* Brazilian numbers *)

var
  c, n: integer;

  function samedigits(n: integer; b: integer): boolean;
    (* Result: true if n has same digits in the base b, false otherwise *)
  var
    f: integer;
    sd: boolean;
  begin
    f := n mod b; n := n div b;
    sd := true;
    while sd and (n > 0) do
      if n mod b <> f then sd := false
      else n := n div b;
    samedigits := sd
  end;

  function isbrazilian(n: integer): boolean;
  var
    b, nm2: integer;
    br: boolean;
  begin
    if n < 7 then isbrazilian := false
    else if (n mod 2 = 0) and (n >= 8) then isbrazilian := true
    else
    begin
      b := 2; nm2 := n - 2;
      br := false;
      while (not br) and (b <= nm2) do
        if samedigits(n, b) then br := true
        else b := b + 1;
      isbrazilian := br
    end;
  end;

  function isprime(n: integer): boolean;
  var
    d: integer;
    pr: boolean;
  begin
    if n < 2 then isprime := false
    else if n mod 2 = 0 then isprime := n = 2
    else if n mod 3 = 0 then isprime := n = 3
    else
    begin
      d := 5;
      pr := true;
      while pr and (d * d <= n) do
        if n mod d = 0 then pr := false
        else
        begin
          d := d + 2;
          if n mod d = 0 then pr := false
          else d := d + 4;
        end;
      isprime := pr
    end;
  end;

begin
  writeln('First 20 Brazilian numbers:');
  c := 0; n := 7;
  while c < 20 do
  begin
    if isbrazilian(n) then
    begin
      write(n:10 );
      c := c + 1;
    end;
    n := n + 1;
  end;
  writeln; writeln;
  writeln('First 20 odd Brazilian numbers:');
  c := 0; n := 7;
  while c < 20 do
  begin
    if isbrazilian(n) then
    begin
      write(n:10);
      c := c + 1;
    end;
    n := n + 2;
  end;
  writeln; writeln;
  writeln('First 20 prime Brazilian numbers:');
  c := 0; n := 7;
  while c < 20 do
  begin
    if isbrazilian(n) then
    begin
      write(n:10);
      c := c + 1;
    end;
    repeat
      n := n + 2;
    until isprime(n);
  end;
  writeln;
end.
