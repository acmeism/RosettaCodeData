##
function is_idoneal(num: integer): boolean;
begin
  for var a := 1 to num do
    for var b := a + 1 to num do
    begin
      if a * b + a + b > num then break;
      for var c := b + 1 to num do
      begin
        var sum3 := a * b + b * c + a * c;
        if sum3 = num then
        begin
          result := False;
          exit;
        end;
        if sum3 > num then break
      end;
    end;
  result := True;
end;

var idoneals := (1..1000_000).Where(x -> is_idoneal(x)).Take(65);
foreach var n in idoneals index i do
  write(n:5, if i mod 10 = 9 then #10 else '');
