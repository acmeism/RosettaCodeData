begin
  var (s1,s2) := ('Bye','Hello');
  if s1.Length < s2.Length then
    Swap(s1,s2);
  Println(s1,s1.Length);
  Println(s2,s2.Length);
  Println;
  var strArr := |'wolf','cat','crocodile','tiger'|;
  strArr.OrderByDescending(s -> s.Length).PrintLines(s -> $'{s,9} - {s.Length}');
end.
