function H(n: integer): real := (1..n).Sum(i -> 1/i);

begin
  for var i:=1 to 20 do
    Println($'{i,2}:  {H(i),10:f8}');
  var i := 1;
  var num := 1;
  while num < 11 do
  begin
    if H(i) > num then
    begin
      Println('Position of the first harmonic number >',num,':',i);
      num += 1;
    end;
    i += 1;
  end;
end.
