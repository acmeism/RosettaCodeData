function ModInverse(a, m: integer): integer;
begin
  result := 1;
  if m = 1 then exit;
  var m0 := m;
  var (x, y) := (1, 0);
  while a > 1 do
  begin
    var q := a div m;
    (a, m) := (m, a mod m);
    (x, y) := (y, x - q * y);
  end;
  result := if x < 0 then x + m0 else x;
end;

begin
  ModInverse(42, 2017).Println;
end.
