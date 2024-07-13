begin
  var s1: HashSet<string> := HSet('John', 'Serena', 'Bob', 'Mary', 'Serena');
  var s2 := HSet('Jim', 'Mary', 'John', 'Jim', 'Bob');
  Println((s1 - s2) + (s2 - s1));
  Println(s1 - s2);
  Println(s2 - s1);
end.
