function lfact(n: integer): biginteger;
begin
  result := 0;
  var fact := 1bi;
  for var i := 1 to n do
  begin
    result += fact;
    fact *= i;
  end;
end;

begin
  for var n := 0 to 10 do lfact(n).Print;
  println;
  for var n := 2 to 11 do lfact(n * 10).println;
  for var n := 1 to 10 do lfact(n * 1000).tostring.length.print;
end.
