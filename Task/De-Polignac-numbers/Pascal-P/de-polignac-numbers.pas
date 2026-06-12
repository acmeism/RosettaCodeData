program polignac(output);
  (* De Polignac numbers *)

const
  maxnumber = 20000;
  maxpower = 20;
var
  powersof2: array [0..maxpower] of integer;
  prime: array [0..maxnumber] of boolean;
  i, doubli, p, p2, s, sqrtofmax, dpcount: integer;
  found: boolean;
begin
  (* Sieve the primes to maxnumber *)
  prime[0] := false;
  prime[1] := false;
  prime[2] := true;
  i := 3;
  while i <= maxnumber do
  begin
    prime[i] := true;
    i := i + 2;
  end;
  i := 4;
  while i <= maxnumber do
  begin
    prime[i] := false;
    i := i + 2;
  end;
  i := 3;
  sqrtofmax := trunc(sqrt(maxnumber));
  while i <= sqrtofmax do
  begin
    if prime[i] then
    begin
      s := i * i;
      doubli := i + i;
      while s <= maxnumber do
      begin
        prime[s] := false;
        s := s + doubli;
      end;
    end;
    i := i + 2;
  end;
  p2 := 1;
  for i := 1 to maxpower do
  begin
    p2 := p2 * 2;
    powersof2[i] := p2;
  end;
  (* The numbers must be odd and not of the form p + 2^n
     either p is odd and 2^n is even and hence n > 0 and p > 2
     or 2^n is odd and p is even and hence n = 0 and p = 2
     (the only even prime is 2, the only odd 2^n is 1). *)
  (* n = 0, p = 2 *)
  dpcount := 1;
  write(1: 5);
  (* n > 0, p > 2 *)
  i := 5;
  while i <= maxnumber do
  begin
    found := false;
    p := 1;
    while (p <= maxpower) and (not found) and (i > powersof2[p]) do
    begin
      found := prime[i - powersof2[p]];
      p := p + 1;
    end;
    if not found then
    begin
      dpcount := dpcount + 1;
      if dpcount <= 50 then
      begin
        write(i: 5);
        if dpcount mod 10 = 0 then writeln;
      end
    end;
    i := i + 2;
  end;
  writeln('Found ', dpcount: 1, ' de Polignac numbers up to ', maxnumber: 1);
end.
