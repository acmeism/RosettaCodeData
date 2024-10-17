function p(L,n: integer): integer;
begin
  var logof2 := log10(2);
  var places := trunc(log10(L));
  var nfound := 0;
  var i := 1;
  while True do
  begin
    var a := i * logof2;
    var b := trunc(power(10,a-trunc(a)+places));
    if L = b then
    begin
      nfound += 1;
      if nfound = n then break
    end;
    i += 1;
  end;
  Result := i;
end;

begin
  foreach var (L,n) in Arr((12, 1), (12, 2), (123, 45), (123, 12345), (123, 678910)) do
    Println($'p({n},{L}) = {p(n, L)}')
end.
