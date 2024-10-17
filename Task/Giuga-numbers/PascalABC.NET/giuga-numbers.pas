uses School;

begin
  var n := 1;
  var cnt := 0;
  while cnt < 4 do
  begin
    if n.Factorize.All(f -> (f <> n) and (n div f - 1).Divs(f)) then
    begin
      cnt += 1;
      Print(n);
    end;
    n += 1;
  end;
end.
