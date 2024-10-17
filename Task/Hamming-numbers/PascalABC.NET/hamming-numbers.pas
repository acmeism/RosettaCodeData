function Hamming(n: integer): BigInteger;
begin
  var (two,three,five) := (2bi, 3bi, 5bi);
  var h := new BigInteger[n];
  h[0] := 1;
  var (x2,x3,x5) := (2bi, 3bi, 5bi);
  var (i,j,k) := (0, 0, 0);
  for var ind := 1 to n-1 do
  begin
    h[ind] := Min(x2, x3, x5);
    if h[ind] = x2 then
    begin
      i += 1;
      x2 := two * h[i];
    end;
    if h[ind] = x3 then
    begin
      j += 1;
      x3 := three * h[j];
    end;
    if h[ind] = x5 then
    begin
      k += 1;
      x5 := five * h[k];
    end;
  end;
  Result := h[n-1];
end;

begin
  (1..20).Select(x -> Hamming(x)).Println;
  Hamming(1691).Println;
  Hamming(1000000).Println;
end.
