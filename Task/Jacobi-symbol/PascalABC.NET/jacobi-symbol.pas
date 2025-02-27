function jacobi(n, k: integer): integer;
begin
  assert((k > 0) and (k mod 2 = 1));
  n := n mod k;
  result := 1;
  while n <> 0 do
  begin
    while n mod 2 = 0 do
    begin
      n := n shr 1;
      if (k and 7) in [3, 5] then
        result := -result;
    end;
    swap(n, k);
    if ((n and 3) = 3) and ((k and 3) = 3) then
      result := -result;
    n := n mod k;
  end;
  if k <> 1 then result := 0;
end;

begin
  write('n/k|');
  for var n := 1 to 20 do write(n:3);
  writeln(#10, '—' * 64);

  for var k := 1 to 21 step 2 do
  begin
    write(k:2, ' |');
    for var n := 1 to 20 do
      write(jacobi(n, k):3);
    writeln;
  end;
end.
