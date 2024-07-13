function Factors(N: integer): List<integer>;
begin
  var lst := new List<integer>;
  var i := 2;
  while i * i <= N do
  begin
    while N.Divs(i) do
    begin
      if i not in lst then
        lst.Add(i);
      N := N div i;
    end;
    i += 1;
  end;
  if N >= 2 then
    lst.Add(N);
  Result := lst;
end;

function Radical(x: integer) := Factors(x).Product;

begin
  for var i:=1 to 50 do
  begin
    Write(Radical(i):3);
    if i mod 10 = 0 then
      Writeln;
  end;
  Writeln;

  Writeln('Radical(99999) = ',Radical(99999));
  Writeln('Radical(499999) = ',Radical(499999));
  Writeln('Radical(999999) = ',Radical(999999));
  Writeln;

  var a := |0| *8;
  for var i:=1 to 1000000 do
    a[Factors(i).Count] += 1;
  for var i:=0 to 7 do
    Writeln($'{i}: {a[i]}');
end.
