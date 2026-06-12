// Anadromes. Nigel Galloway: August 30th., 2022
begin
  var n := ReadLines('words.txt').Where(n -> Length(n) > 6);
  foreach var v in n.Intersect(n.Select(n -> ReverseString(n))) do if v < ReverseString(v) then writeln(v);
end.
