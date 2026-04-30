function Factors(n: integer): set of integer;
begin
  Result := SetOf(1, n);
  var i := 2;
  while True do
  begin
    var j := n div i;
    if j < i then
      break;
    if i * j = n then
      Result += SetOf(i,j);
    i += 1;
  end;
end;

begin
  var arithmeticCount := 0;
  var compositeCount := 0;
  var n := 1;

  while arithmeticCount <= 1000000 do
  begin
    var f := Factors(n);
    var avg := f.Average;

    if frac(avg) = 0 then
    begin
      arithmeticCount += 1;

      if f.Count > 2 then
        compositeCount += 1;

      if arithmeticCount <= 100 then
      begin
        Print($'{n,3} ');
        if arithmeticCount mod 10 = 0 then
          Println;
      end;

      if arithmeticCount in [1000, 10000, 100000, 1000000] then
      begin
        Println(NewLine + $'{arithmeticCount}th arithmetic number is {n}');
        Println($'Number of composite arithmetic numbers <= {n}: {compositeCount}');
      end;
    end;

    n += 1;
  end;
end.
