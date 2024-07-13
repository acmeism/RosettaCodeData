begin
  var a1 := Arr('a','b','c');
  var a2 := Arr('A','B','C');
  var a3 := Arr(1,2,3);
  for var i:=0 to a1.Length-1 do
    Writeln(a1[i],a2[i],a3[i]);
  Writeln;
  foreach var (x,y,z) in a1.Zip(a2,a3) do
    Writeln(x,y,z);
  Writeln;
  a1.Zip(a2,a3).PrintLines(t -> t[0]+t[1]+t[2]);
end.
