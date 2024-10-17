##
function iskaprekar(n: int64): boolean;
begin
  if n = 1 then result := true;
  var n2 := (n * n).tostring;
  for var i := 2 to n2.length do
  begin
    var a := StrToInt64(n2[:i]);
    var b := StrToInt64(n2[i:]);
    if (b > 0) and (a + b = n) then result := true;
  end;
end;

(1..10_000).Where(x -> iskaprekar(x)).Println;
(1..1_000_000).Where(x -> iskaprekar(x)).Count.Println;
