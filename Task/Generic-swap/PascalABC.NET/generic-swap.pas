procedure Swap<T> (var a,b: T) := (a,b) := (b,a);

begin
  var (i,j) := (1,2);
  Swap(i,j);
  Println(i,j);
  var (s1,s2) := ('PascalABC.NET','Hello');
  Swap(s1,s2);
  Println(s1,s2);
end.
