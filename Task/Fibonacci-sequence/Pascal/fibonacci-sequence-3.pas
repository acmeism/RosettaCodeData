function fib(n: integer): integer;
var
  f0, f1, tmpf0, k: integer;
begin
  f1 := n;
  IF f1 >1 then
  begin
    k := f1-1;
    f0 := 0;
    f1 := 1;
    repeat
      tmpf0 := f0;
      f0 := f1;
      f1 := f1+tmpf0;
      dec(k);
    until k = 0;
  end
  else
    IF f1 < 0 then
      f1 := 0;
  fib := f1;
end;
